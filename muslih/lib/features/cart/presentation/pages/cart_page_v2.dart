import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_localizations.dart';

// --- Cart Page v2 -------------------------------------------
class CartPageV2 extends ConsumerWidget {
  const CartPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = const CartLang();
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(lang.myCart)),
      body: Center(
        child: Text(lang.emptyCart,
            style: TextStyle(color: Colors.grey.shade500)),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang.total,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              ElevatedButton(
                onPressed: () {},
                child: Text(lang.checkout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Favorites Page v2 -------------------------------------------
class FavoritesPageV2 extends ConsumerWidget {
  const FavoritesPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = const CartLang();

    return Scaffold(
      appBar: AppBar(title: Text(lang.myFavorites)),
      body: Center(
        child: Text(lang.emptyFavorites,
            style: TextStyle(color: Colors.grey.shade500)),
      ),
    );
  }
}