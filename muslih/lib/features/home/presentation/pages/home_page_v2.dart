import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/features/market/domain/entities/service_category.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';

// --- Home Page (Bottom Nav Index 0) -------------------------------
class HomePageV2 extends ConsumerWidget {
  const HomePageV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme.primary;
    final query = ref.watch(searchProvider);
    final filtered = query.isEmpty
        ? ServiceCategories.all
        : ServiceCategories.all
            .where((c) => c.name.contains(query))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('مُصلح'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (v) => ref.read(searchProvider.notifier).state = v,
              decoration: InputDecoration(
                hintText: 'ابحث عن خدمة...',
                prefixIcon: Icon(Icons.search, color: color),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Categories Grid
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
                return InkWell(
                  onTap: () => context.push('/providers-list/${cat.id}'),
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
                            ServiceCategories.iconFor(cat.iconName),
                            color: color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            cat.name,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}