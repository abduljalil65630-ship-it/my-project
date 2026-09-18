import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muslih/core/widgets/shimmer_loading.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/features/market/domain/entities/service_category.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';

/// صفحة قائمة المزودين ضمن فئة معيّنة (أو الكل).
class ProvidersListPage extends ConsumerWidget {
  const ProvidersListPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = ProvidersParams(categoryId: categoryId);
    final providersAsync = ref.watch(providersProvider(params));

    final categoryName = categoryId == null
        ? 'كل المزودين'
        : ServiceCategories.all
            .firstWhere((c) => c.id == categoryId,
                orElse: () => const ServiceCategory(id: '', name: ''))
            .name;

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: providersAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const Card(
            child: ListTile(
              leading: ShimmerLoading(width: 52, height: 52, borderRadius: 26),
              title: ShimmerLoading(width: 150, height: 16),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: ShimmerLoading(width: 100, height: 12),
              ),
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Text('خطأ: $e',
              style: const TextStyle(color: Color(0xFFD14343))),
        ),
        data: (providers) {
          if (providers.isEmpty) {
            return const Center(
              child: Text('لا يوجد مزودون بعد في هذه الفئة.',
                  style: TextStyle(color: Color(0xFF6B7280))),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: providers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final p = providers[i];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  onTap: () => context.push('/provider/${p.id}'),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFE3F0EC),
                    backgroundImage: p.avatarUrl != null
                        ? CachedNetworkImageProvider(p.avatarUrl!)
                        : null,
                    child: p.avatarUrl == null
                        ? Icon(ServiceCategories.iconFor(p.categoryId),
                            color: const Color(0xFF1E6B5A))
                        : null,
                  ),
                  title: Row(
                    children: [
                      Expanded(child: Text(p.fullName)),
                      if (p.isVerified)
                        const Icon(Icons.verified,
                            color: Color(0xFF2E9E5B), size: 16),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: Color(0xFFF2A900)),
                      Text(' ${p.rating.toStringAsFixed(1)} '
                          '· ${p.completedJobs} طلب مكتمل'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_back_ios),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
