import 'package:muslih/features/auth/domain/entities/app_user.dart';

/// نموذج المستخدم المعياري لقاعدة البيانات (JSON ↔ Entity).
class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String role;
  final String? avatarUrl;
  final String? pushToken;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    required this.role,
    this.avatarUrl,
    this.pushToken,
    required this.createdAt,
  });

  /// من صف JSON قادم من Supabase.
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        role: (json['role'] as String?) ?? 'customer',
        avatarUrl: json['avatar_url'] as String?,
        pushToken: json['push_token'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  /// إلى كيان التطبيق.
  AppUser toEntity() => AppUser(
        id: id,
        fullName: fullName,
        phone: phone,
        email: email,
        role: UserRole.fromValue(role),
        avatarUrl: avatarUrl,
        pushToken: pushToken,
        createdAt: createdAt,
      );

  Map<String, dynamic> toInsertJson() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'email': email,
        'role': role,
        'avatar_url': avatarUrl,
        'push_token': pushToken,
      };
}
