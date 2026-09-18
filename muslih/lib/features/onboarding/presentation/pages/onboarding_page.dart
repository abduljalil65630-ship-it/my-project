import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Onboarding Page --------------------------------------------------------
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageCtrl = PageController();
  int _page = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': S.onboardingTitle1,
      'titleEn': S.onboardingTitle1En,
      'desc': S.onboardingDesc1,
      'descEn': S.onboardingDesc1En,
      'icon': Icons.home_repair_service,
    },
    {
      'title': S.onboardingTitle2,
      'titleEn': S.onboardingTitle2En,
      'desc': S.onboardingDesc2,
      'descEn': S.onboardingDesc2En,
      'icon': Icons.shopping_cart_checkout,
    },
    {
      'title': S.onboardingTitle3,
      'titleEn': S.onboardingTitle3En,
      'desc': S.onboardingDesc3,
      'descEn': S.onboardingDesc3En,
      'icon': Icons.chat_bubble_outline,
    },
  ];

  bool _lastPage() => _page >= _pages.length - 1;

  void _next() {
    if (_lastPage()) {
      ref.read(localeProvider.notifier).state = const Locale('ar');
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _skip() {
    ref.read(localeProvider.notifier).state = const Locale('ar');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final lang = const S();
    final isEn = Localizations.localeOf(context).languageCode == 'en';
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final p = _pages[i];
                  return _OnboardingCard(
                    icon: Icon(p['icon'], size: 96, color: color),
                    title: isEn ? (p['titleEn'] ?? p['title']) : p['title']!,
                    desc: isEn ? (p['descEn'] ?? p['desc']) : p['desc']!,
                    color: color,
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _page == i ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _page == i ? color : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    // Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _next,
                        child: Text(_lastPage() ? lang.getStarted : lang.next),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(onPressed: _skip, child: Text(lang.skip)),
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
