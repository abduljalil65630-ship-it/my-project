import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:muslih/core/config/supabase_config.dart';
import 'package:muslih/core/router/app_router.dart';
import 'package:muslih/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Supabase
  await initializeSupabase();
  
  // تهيئة Firebase (يتطلب ملف google-services.json ليعمل فعلياً)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const ProviderScope(child: MuslihApp()));
}

class MuslihApp extends ConsumerStatefulWidget {
  const MuslihApp({super.key});

  @override
  ConsumerState<MuslihApp> createState() => _MuslihAppState();
}

class _MuslihAppState extends ConsumerState<MuslihApp> {
  @override
  void initState() {
    super.initState();
    // تهيئة نظام التنبيهات بعد تشغيل التطبيق
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'مُصلح',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
  }
}
