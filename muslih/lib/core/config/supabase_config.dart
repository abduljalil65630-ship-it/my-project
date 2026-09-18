import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';

import 'package:muslih/core/services/storage_service.dart';
import 'package:muslih/core/services/location_service.dart';
import 'package:muslih/core/services/notification_service.dart';

/// مزوّد (Provider) عميل Supabase المُهيّأ مرة واحدة في التطبيق.
///
/// نستخدم [Provider] من Riverpod لأن العميل ثابت طول عمر التطبيق.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// مزوّد خدمة التخزين.
final storageServiceProvider = Provider<StorageService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return StorageService(client);
});

/// مزوّد خدمة الموقع.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// مزوّد خدمة التنبيهات.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return NotificationService(client);
});

/// يُهيّئ Supabase قبل تشغيل التطبيق (يُستدعى في [main]).
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    // authFlowType: AuthFlowType.pkce, // فعّل عند الحاجة لتسجيل الدخول عبر الرابط
  );
}
