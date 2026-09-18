import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/features/market/domain/entities/service_category.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Categories Page v2 ------------------------------------------------
class CategoriesPageV2 extends ConsumerWidget {
  const CategoriesPageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = const S();
    final color = Theme.of(context).colorScheme.primary;
    final query = ref.watch(searchProvider);
    final filtered = query.isEmpty
        ? ServiceCategories.all
        : ServiceCategories.all
            .where((c) => c.name.contains(query))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => ref.read(searchProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: lang.search,
                prefixIcon: Icon(Icons.search, color: color),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final cat = filtered[i];
                return _CategoryCardV2(category: cat, color: color);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCardV2 extends StatelessWidget {
  final ServiceCategory category;
  final Color color;

  const _CategoryCardV2({required this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/providers-list/${category.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withValues(alpha: 0.1),
              child: Icon(
                ServiceCategories.iconFor(category.iconName),
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}