import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:muslih/core/config/supabase_config.dart';
import 'package:muslih/features/market/data/repositories/market_repository_impl.dart';
import 'package:muslih/features/market/data/repositories/request_repository_impl.dart';
import 'package:muslih/features/market/domain/entities/provider.dart';
import 'package:muslih/features/market/domain/repositories/market_repository.dart';
import 'package:muslih/features/market/domain/repositories/request_repository.dart';
import 'package:muslih/features/market/domain/entities/provider_service.dart';
import 'package:muslih/features/market/data/repositories/chat_repository_impl.dart';
import 'package:muslih/features/market/domain/repositories/chat_repository.dart';
import 'package:muslih/features/market/domain/entities/message.dart';

/// مستودع السوق.
final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// مستودع الطلبات.
final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  return RequestRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// مستودع المحادثات.
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(supabaseClientProvider));
});

/// بث رسائل المحادثة لطلب معين.
final chatMessagesProvider = StreamProvider.family<List<Message>, String>((ref, requestId) {
  return ref.watch(chatRepositoryProvider).getMessagesStream(requestId);
});

/// طلبات العميل.
final customerRequestsProvider = FutureProvider.family<List<ServiceRequest>, String>((ref, customerId) {
  return ref.watch(requestRepositoryProvider).getCustomerRequests(customerId);
});

/// طلبات المزود الواردة.
final providerRequestsProvider = FutureProvider.family<List<ServiceRequest>, String>((ref, providerId) {
  return ref.watch(requestRepositoryProvider).getProviderRequests(providerId);
});

/// قائمة المزودين لفئة معيّنة (أو الكل).
final providersProvider =
    FutureProvider.family<List<ServiceProvider>, ProvidersParams>((ref, params) {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getProviders(
      categoryId: params.categoryId, city: params.city);
});

/// مزوّد تفاصيل مزوّد واحد.
final providerDetailProvider =
    FutureProvider.family<ServiceProvider, String>((ref, id) {
  final repo = ref.watch(marketRepositoryProvider);
  return repo.getProviderById(id);
});

/// نتائج البحث.
final searchProvider = StateProvider<String>((ref) => '');

/// معاملات استعلام المزودين.
class ProvidersParams {
  const ProvidersParams({this.categoryId, this.city});
  final String? categoryId;
  final String? city;

  @override
  bool operator ==(Object other) =>
      other is ProvidersParams &&
      other.categoryId == categoryId &&
      other.city == city;

  @override
  int get hashCode => categoryId.hashCode ^ city.hashCode;
}
final providerServicesProvider =
    FutureProvider.family<List<ProviderService>, String>((ref, id) {
  return ref.watch(marketRepositoryProvider).getProviderServices(id);
});
