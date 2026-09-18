import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:muslih/core/config/supabase_config.dart';
import 'package:muslih/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:muslih/features/auth/domain/entities/app_user.dart';
import 'package:muslih/features/auth/domain/repositories/auth_repository.dart';
import 'package:muslih/features/auth/presentation/providers/auth_controller.dart';

/// مزوّد المستودع — يربط العقد بتنفيذه (Supabase).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
});

/// مزوّد حالة المصادقة (UI state) للشاشات.
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});

/// مزوّد يراقب المستخدم الحالي (مفيد للتوجيه).
final currentUserProvider = FutureProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getCurrentUser();
});
