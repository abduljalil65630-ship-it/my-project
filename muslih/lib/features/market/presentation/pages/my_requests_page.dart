import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';
import 'package:intl/intl.dart' as intl;

class MyRequestsPage extends ConsumerWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    
    if (user == null) {
      return const Scaffold(body: Center(child: Text('يجب تسجيل الدخول')));
    }

    final requestsAsync = ref.watch(customerRequestsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('لا يوجد طلبات حالياً'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(req.title),
                  subtitle: Text(
                    '${req.status.label} · ${intl.DateFormat('yyyy/MM/dd').format(req.createdAt)}',
                  ),
                  trailing: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1E6B5A)),
                  onTap: () {
                    context.push('/chat/${req.id}/${req.title}');
                  },
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
}
