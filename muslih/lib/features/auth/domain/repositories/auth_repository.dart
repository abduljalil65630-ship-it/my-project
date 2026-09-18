import 'package:muslih/features/auth/domain/entities/app_user.dart';

/// العقد (Interface) لمستودع المصادقة — لا يعرف المصدر (Supabase).
///
/// تطبيقه موجود في طبقة data. هذا يفصل منطق التطبيق عن التفاصيل
/// ويسمح باستبدال المصدر أو وهمه (Mock) بسهولة في الاختبارات.
abstract class AuthRepository {
  /// بيانات المستخدم الحالي إن كان مسجّلاً.
  Future<AppUser?> getCurrentUser();

  /// تسجيل دخول برقم هاتف وكلمة مرور.
  Future<AppUser> login({required String phone, required String password});

  /// إنشاء حساب جديد (عميل أو مزوّد).
  Future<AppUser> register({
    required String fullName,
    required String phone,
    required String password,
    required UserRole role,
    String? email,
  });

  /// تسجيل الخروج.
  Future<void> logout();

  /// تحديث بيانات الملف الشخصي.
  Future<AppUser> updateProfile({
    required String id,
    String? fullName,
    String? avatarUrl,
  });
}
