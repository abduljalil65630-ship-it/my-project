import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:muslih/core/constants/app_constants.dart';
import 'package:muslih/core/config/supabase_config.dart';
import 'package:muslih/features/auth/domain/entities/app_user.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';

/// صفحة الحساب: بيانات المستخدم + تسجيل الخروج + تعديل الصورة.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isUploading = false;

  Future<void> _changeAvatar(String userId) async {
    final storage = ref.read(storageServiceProvider);
    
    // 1. اختيار الصورة
    final File? file = await storage.pickImage();
    if (file == null) return;

    setState(() => _isUploading = true);

    try {
      // 2. رفع الصورة إلى Supabase Storage
      final String? imageUrl = await storage.uploadImage(
        file: file,
        bucket: 'avatars',
        path: 'users/$userId',
      );

      if (imageUrl != null) {
        // 3. تحديث رابط الصورة في جدول الـ profiles
        await ref.read(authControllerProvider.notifier).updateProfile(
              avatarUrl: imageUrl,
            );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث الصورة الشخصية بنجاح')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<AppUser?>>(authControllerProvider, (prev, next) {
      if (next.hasValue && next.value == null) {
        context.go('/login');
      }
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${next.error}')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('حسابي')),
      body: authState.isLoading || _isUploading
          ? const Center(child: CircularProgressIndicator())
          : userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (user) {
                if (user == null) {
                  return const Center(child: Text('لم تسجّل الدخول'));
                }
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFE3F0EC),
                            backgroundImage: user.avatarUrl != null
                                ? CachedNetworkImageProvider(user.avatarUrl!)
                                : null,
                            child: user.avatarUrl == null
                                ? Text(
                                    user.fullName.isNotEmpty
                                        ? user.fullName[0]
                                        : '؟',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        color: Color(0xFF1E6B5A)),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFF1E6B5A),
                              radius: 18,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    size: 18, color: Colors.white),
                                onPressed: () => _changeAvatar(user.id),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(user.fullName,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F0EC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.role == UserRole.provider
                              ? 'مزوّد خدمة'
                              : 'عميل',
                          style: const TextStyle(
                              color: Color(0xFF1E6B5A),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInfoTile(Icons.phone, 'رقم الهاتف', user.phone),
                    if (user.email != null)
                      _buildInfoTile(Icons.email, 'البريد الإلكتروني', user.email!),
                    const Divider(height: 40),
                    ListTile(
                      leading: const Icon(Icons.assignment, color: Color(0xFF1E6B5A)),
                      title: const Text('طلباتي'),
                      trailing: const Icon(Icons.arrow_back_ios, size: 16),
                      onTap: () => context.push('/my-requests'),
                    ),
                    if (user.role == UserRole.provider)
                      ListTile(
                        leading: const Icon(Icons.work_outline, color: Color(0xFF1E6B5A)),
                        title: const Text('طلبات العمل الواردة'),
                        trailing: const Icon(Icons.arrow_back_ios, size: 16),
                        onTap: () => context.push('/provider-orders'),
                      ),
                    ListTile(
                      leading: const Icon(Icons.logout,
                          color: Color(0xFFD14343)),
                      title: const Text('تسجيل الخروج',
                          style: TextStyle(color: Color(0xFFD14343))),
                      onTap: () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .logout();
                      },
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text('${AppConstants.appName} v1.1.0',
                          style: TextStyle(
                              color: Color(0xFF6B7280), fontSize: 12)),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6B7280)),
      title: Text(label,
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13)),
      subtitle: Text(value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
    );
  }
}
