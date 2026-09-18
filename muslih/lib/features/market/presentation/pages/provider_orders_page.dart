import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';
import 'package:muslih/features/market/domain/entities/provider.dart';
import 'package:intl/intl.dart' as intl;

class ProviderOrdersPage extends ConsumerWidget {
  const ProviderOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    if (user == null) return const Scaffold(body: Center(child: Text('يجب تسجيل الدخول')));

    final ordersAsync = ref.watch(providerRequestsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('طلبات العمل الواردة')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('لا يوجد طلبات عمل جديدة حالياً'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(order.title),
                      subtitle: Text(
                        '${order.city} · ${intl.DateFormat('yyyy/MM/dd').format(order.createdAt)}',
                      ),
                      trailing: _buildStatusChip(order.status),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(order.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    ButtonBar(
                      children: [
                        if (order.status == RequestStatus.pending) ...[
                          TextButton(
                            onPressed: () => _updateStatus(ref, order.id, RequestStatus.rejected),
                            child: const Text('رفض', style: TextStyle(color: Colors.red)),
                          ),
                          ElevatedButton(
                            onPressed: () => _updateStatus(ref, order.id, RequestStatus.accepted),
                            child: const Text('قبول'),
                          ),
                        ],
                        IconButton(
                          icon: const Icon(Icons.chat, color: Color(0xFF1E6B5A)),
                          onPressed: () => context.push('/chat/${order.id}/${order.title}'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
      ),
    );
  }

  Widget _buildStatusChip(RequestStatus status) {
    Color color = Colors.grey;
    if (status == RequestStatus.accepted) color = Colors.green;
    if (status == RequestStatus.rejected) color = Colors.red;
    if (status == RequestStatus.completed) color = Colors.blue;

    return Chip(
      label: Text(status.label, style: const TextStyle(fontSize: 10, color: Colors.white)),
      backgroundColor: color,
    );
  }

  void _updateStatus(WidgetRef ref, String id, RequestStatus status) {
    ref.read(requestRepositoryProvider).updateRequestStatus(id, status).then((_) {
      // تحديث القائمة
      final user = ref.read(authControllerProvider).valueOrNull;
      if (user != null) {
        ref.invalidate(providerRequestsProvider(user.id));
      }
    });
  }
}
