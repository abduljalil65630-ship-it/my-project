import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:muslih/core/errors/failures.dart';
import 'package:muslih/features/auth/data/models/user_model.dart';
import 'package:muslih/features/auth/domain/entities/app_user.dart';
import 'package:muslih/features/auth/domain/repositories/auth_repository.dart';

/// تنفيذ مستودع المصادقة باستخدام Supabase.
///
/// Supabase Auth مسؤول عن:
/// - إنشاء المستخدم
/// - تسجيل الدخول
/// - تسجيل الخروج
///
/// جدول profiles مسؤول عن:
/// - الاسم
/// - رقم الهاتف
/// - نوع الحساب
/// - البريد الحقيقي إن وجد
/// - بيانات المستخدم الإضافية
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._client);

  final SupabaseClient _client;

  // =========================================================
  // الحصول على المستخدم الحالي
  // =========================================================

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;

      // لا يوجد مستخدم مسجل دخول
      if (user == null) {
        return null;
      }

      // الحصول على بيانات المستخدم من profiles
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // لم يتم العثور على profile
      if (row == null) {
        return null;
      }

      return UserModel.fromJson(row).toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(
        e.message,
        e.statusCode,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(
        'خطأ قاعدة البيانات: ${e.message}',
      );
    } catch (e) {
      throw UnexpectedFailure(
        e.toString(),
      );
    }
  }

  // =========================================================
  // تسجيل الدخول
  // =========================================================

  @override
  Future<AppUser> login({
    required String phone,
    required String password,
  }) async {
    try {
      // تنظيف رقم الهاتف
      final cleanPhone = phone.trim();

      // تحويل الهاتف إلى البريد الداخلي
      final emailForLogin = _phoneToEmail(cleanPhone);

      // تسجيل الدخول في Supabase Auth
      final res = await _client.auth.signInWithPassword(
        email: emailForLogin,
        password: password,
      );

      final user = res.user;

      if (user == null) {
        throw const AuthFailure(
          'فشل تسجيل الدخول',
        );
      }

      // الحصول على Profile
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(row).toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(
        e.message,
        e.statusCode,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(
        'خطأ قاعدة البيانات: ${e.message}',
      );
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }

      throw const AuthFailure(
        'بيانات الدخول غير صحيحة',
      );
    }
  }

  // =========================================================
  // إنشاء حساب جديد
  // =========================================================

  @override
  Future<AppUser> register({
    required String fullName,
    required String phone,
    required String password,
    required UserRole role,
    String? email,
  }) async {
    try {
      // -----------------------------------------------------
      // تنظيف البيانات
      // -----------------------------------------------------

      final cleanName = fullName.trim();

      final cleanPhone = phone.trim();

      final cleanEmail = email?.trim();

      // -----------------------------------------------------
      // إنشاء البريد الداخلي
      //
      // هذا البريد يستخدم فقط مع Supabase Auth.
      //
      // مثال:
      // 777123456
      // يصبح:
      // 777123456@muslih.app
      // -----------------------------------------------------

      final emailForLogin = _phoneToEmail(cleanPhone);

      // -----------------------------------------------------
      // إنشاء المستخدم في Supabase Auth
      // -----------------------------------------------------

      final authRes = await _client.auth.signUp(
        email: emailForLogin,
        password: password,

        // البيانات الإضافية التي سيستخدمها Trigger
        data: {
          'full_name': cleanName,
          'phone': cleanPhone,
          'role': role.value,

          // البريد الحقيقي اختياري
          if (cleanEmail != null && cleanEmail.isNotEmpty)
            'real_email': cleanEmail,
        },
      );

      // -----------------------------------------------------
      // الحصول على المستخدم
      // -----------------------------------------------------

      final user = authRes.user;

      if (user == null) {
        throw const AuthFailure(
          'فشل إنشاء الحساب',
        );
      }

      // -----------------------------------------------------
      // إذا لم توجد Session
      //
      // يحدث غالبًا عندما يكون Email Confirmation مفعلاً.
      // -----------------------------------------------------

      if (authRes.session == null) {
        throw const AuthFailure(
          'تم إنشاء الحساب، ولكن يلزم تأكيد الحساب قبل تسجيل الدخول.',
        );
      }

      // -----------------------------------------------------
      // Trigger يقوم بإنشاء profiles تلقائيًا.
      //
      // لذلك نحن لا ننفذ INSERT هنا.
      // -----------------------------------------------------

      final row = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      // -----------------------------------------------------
      // تحويل البيانات إلى AppUser
      // -----------------------------------------------------

      return UserModel.fromJson(row).toEntity();
    } on AuthException catch (e) {
      throw AuthFailure(
        e.message,
        e.statusCode,
      );
    } on PostgrestException catch (e) {
      throw ServerFailure(
        'خطأ قاعدة البيانات: ${e.message}',
      );
    } catch (e) {
      if (e is Failure) {
        rethrow;
      }

      throw ServerFailure(
        'تعذر إكمال التسجيل: $e',
      );
    }
  }

  // =========================================================
  // تسجيل الخروج
  // =========================================================

  @override
  Future<void> logout() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(
        e.message,
        e.statusCode,
      );
    } catch (e) {
      throw UnexpectedFailure(
        e.toString(),
      );
    }
  }

  @override
  Future<AppUser> updateProfile({
    required String id,
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final updates = {
        if (fullName != null) 'full_name': fullName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      };

      if (updates.isEmpty) {
        throw const UnexpectedFailure('لا توجد بيانات لتحديثها');
      }

      final row = await _client
          .from('profiles')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      // إذا كان مزود خدمة، نحدث بياناته في جدول الـ providers أيضاً
      if (avatarUrl != null || fullName != null) {
        final profileRole = row['role'];
        if (profileRole == 'provider') {
          await _client.from('providers').update({
            if (fullName != null) 'full_name': fullName,
            if (avatarUrl != null) 'avatar_url': avatarUrl,
          }).eq('id', id);
        }
      }

      return UserModel.fromJson(row).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure('فشل تحديث الملف الشخصي: ${e.message}');
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // =========================================================
  // تحويل رقم الهاتف إلى بريد داخلي
  // =========================================================

  String _phoneToEmail(String phone) {
    final cleanPhone = phone.replaceAll(
      RegExp(r'\D'),
      '',
    );

    return '$cleanPhone@muslih.app';
  }
}