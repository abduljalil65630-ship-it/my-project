import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:muslih/core/constants/app_constants.dart';

/// شاشة البداية: تتحقق من الجلسة ثم توجّه لمكانها.
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // تأخير بسيط لعرض الشعار ثم التوجيه بناءً على حالة الدخول.
    Timer(const Duration(seconds: 2), () {
      final loggedIn =
          Supabase.instance.client.auth.currentSession != null;
      if (context.mounted) {
        context.go(loggedIn ? '/' : '/login');
      }
    });

    return const Scaffold(
      backgroundColor: Color(0xFF1E6B5A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handyman_rounded,
                size: 96, color: Colors.white),
            SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'مزودو الخدمات المنزلية الموثوقون',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 28),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
