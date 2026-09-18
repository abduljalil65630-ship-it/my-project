import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:muslih/features/auth/domain/entities/app_user.dart';
import 'package:muslih/features/auth/domain/repositories/auth_repository.dart';

/// متحكم حالة المصادقة.
class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  AuthController(this._repository) : super(const AsyncValue.data(null)) {
    _loadCurrentUser();
  }

  final AuthRepository _repository;

  /// تحميل المستخدم الحالي عند تشغيل التطبيق.
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _repository.getCurrentUser();

      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// تسجيل الدخول.
  Future<bool> login({
    required String phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final user = await _repository.login(
        phone: phone,
        password: password,
      );

      state = AsyncValue.data(user);

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);

      return false;
    }
  }

  /// إنشاء حساب جديد.
  ///
  /// بعد نجاح التسجيل:
  /// - يتم إنشاء المستخدم في Supabase Auth.
  /// - Trigger ينشئ profile.
  /// - يتم تسجيل الخروج من Session التسجيل.
  /// - يبقى المستخدم في صفحة تسجيل الدخول.
  Future<void> register({
    required String fullName,
    required String phone,
    required String password,
    required UserRole role,
    String? email,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repository.register(
        fullName: fullName,
        phone: phone,
        password: password,
        role: role,
        email: email,
      );

      await _repository.logout();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// تسجيل الخروج.
  Future<bool> logout() async {
    try {
      await _repository.logout();

      state = const AsyncValue.data(null);

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);

      return false;
    }
  }

  /// تحديث الملف الشخصي.
  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    final currentSession = state.value;
    if (currentSession == null) return;

    state = const AsyncValue.loading();

    try {
      final updatedUser = await _repository.updateProfile(
        id: currentSession.id,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );

      state = AsyncValue.data(updatedUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
