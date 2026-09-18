import 'package:equatable/equatable.dart';

/// الكيان الأساسي للمستخدم (مستقل عن قاعدة البيانات).
///
/// هذا هو ما تتعامل معه طبقات العرض والمنطق — وليس نموذج الـ JSON.
class AppUser extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final UserRole role;
  final String? avatarUrl;
  final String? pushToken;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
    this.avatarUrl,
    this.pushToken,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, fullName, phone, email, role, avatarUrl, pushToken, createdAt];
}

/// دور المستخدم في المنصة (عميل أو مزوّد خدمة).
enum UserRole {
  customer('customer', 'عميل'),
  provider('provider', 'مزوّد خدمة');

  final String value;
  final String label;
  const UserRole(this.value, this.label);

  static UserRole fromValue(String? v) =>
      UserRole.values.firstWhere((e) => e.value == v,
          orElse: () => UserRole.customer);
}
