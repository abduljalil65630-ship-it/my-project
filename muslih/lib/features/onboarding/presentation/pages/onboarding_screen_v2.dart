import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Onboarding Screen v2 -------------------------------
class OnboardingScreenV2 extends StatelessWidget {
  const OnboardingScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView(
                children: [
                  _OnboardingCard(
                    icon: Icon(Icons.home_repair_service, size: 64, color: color),
                    title: 'ابحث عن مزوّد موثوق',
                    desc: 'استكشف قائمة واسعة من مزودي الخدمات المنزلية الموثوقين',
                    color: color,
                  ),
                  _OnboardingCard(
                    icon: Icon(Icons.shopping_cart_checkout, size: 64, color: color),
                    title: 'اطلب الخدمة بسهولة',
                    desc: 'حدّد الخدمة، أرسل الطلب، وتابع حالة تنفيذه',
                    color: color,
                  ),
                  _OnboardingCard(
                    icon: Icon(Icons.chat_bubble_outline, size: 64, color: color),
                    title: 'تواصل مع المزوّد',
                    desc: 'احصل على تحديثات فورية وتواصل مباشر مع مزوّد الخدمة',
                    color: color,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.push('/login'),
                        child: Text('ابدأ الآن'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: Text('تخطي'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String desc;
  final Color color;

  const _OnboardingCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}