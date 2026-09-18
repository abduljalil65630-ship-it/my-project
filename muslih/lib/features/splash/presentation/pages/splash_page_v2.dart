import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';

// --- Splash Page v2 -------------------------------
class SplashPageV2 extends ConsumerStatefulWidget {
  const SplashPageV2({super.key});

  @override
  ConsumerState<SplashPageV2> createState() => _SplashPageV2State();
}

class _SplashPageV2State extends ConsumerState<SplashPageV2> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final loggedIn = ref.read(authControllerProvider).valueOrNull != null;
        context.go(loggedIn ? '/' : '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_repair_service, size: 96, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'مُصلح',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'مزودو الخدمات المنزلية الموثوقون',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 28),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}