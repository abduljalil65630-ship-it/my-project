import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';
import 'package:muslih/features/home/presentation/pages/home_page_v2.dart';
import 'package:muslih/features/cart/presentation/pages/cart_page_v2.dart';
import 'package:muslih/features/profile/presentation/pages/profile_page_v2.dart';

// --- Favorites stub -------------------------------
class FavoritesPageV2 extends StatelessWidget {
  const FavoritesPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المفضلة')),
      body: Center(child: Text('لا توجد خدمات مفضلة بعد')),
    );
  }
}

// --- Main Scaffold with Bottom Navigation -------------------------------
class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  int _currentIndex = 0;

  final _pages = [
    const HomePageV2(),
    const CartPageV2(),
    const FavoritesPageV2(),
    const ProfilePageV2(),
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'السلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'المفضلة',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}