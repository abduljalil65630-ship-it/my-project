import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:muslih/features/market/presentation/providers/market_providers.dart';

/// صفحة تفاصيل مزوّد واحد مع زر "اطلب الخدمة".
class ProviderDetailPage extends ConsumerWidget {
  const ProviderDetailPage({super.key, required this.providerId});

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(providerDetailProvider(providerId));

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المزوّد')),
      body: providerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('خطأ: $e',
              style: const TextStyle(color: Color(0xFFD14343))),
        ),
        data: (p) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: const Color(0xFFE3F0EC),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: const Color(0xFF1E6B5A),
                      backgroundImage: p.avatarUrl != null
                          ? CachedNetworkImageProvider(p.avatarUrl!)
                          : null,
                      child: p.avatarUrl == null
                          ? Text(p.fullName.isNotEmpty
                          ? p.fullName[0]
                          : '؟')
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p.fullName,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        if (p.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified,
                              color: Color(0xFF2E9E5B), size: 18),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(p.categoryName,
                        style: const TextStyle(color: Color(0xFF6B7280))),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Color(0xFFF2A900)),
                        const SizedBox(width: 4),
                        Text('${p.rating.toStringAsFixed(1)} '
                            '(${p.reviewCount} تقييماً)'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('نبذة'),
                    Text(p.bio ?? 'لا توجد نبذة.',
                        style: const TextStyle(color: Color(0xFF6B7280))),
                    const SizedBox(height: 16),
                    const _SectionTitle('المعلومات'),
                    _InfoRow(Icons.location_on, 'المدينة',
                        p.city ?? 'غير محددة'),
                    _InfoRow(Icons.work_history, 'الطلبات المكتملة',
                        '${p.completedJobs}'),
                    _InfoRow(
                        Icons.payments,
                        'السعر التقديري',
                        p.hourlyRate != null
                            ? '${p.hourlyRate!.toStringAsFixed(0)} / الساعة'
                            : 'حسب الاتفاق'),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            context.push('/request/${p.id}'),
                        icon: const Icon(Icons.send),
                        label: const Text('اطلب الخدمة'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('ميزة المحادثة قيد التطوير')),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('مراسلة'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16)),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1E6B5A)),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(color: Color(0xFF6B7280))),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
