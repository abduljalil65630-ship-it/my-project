import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:muslih/features/market/domain/entities/provider.dart';
import 'package:muslih/features/market/domain/repositories/request_repository.dart';
import 'package:muslih/features/market/presentation/providers/market_providers.dart';

/// متحكّم إنشاء طلب خدمة (UI state).
class RequestController extends StateNotifier<AsyncValue<ServiceRequest?>> {
  RequestController(this._repository) : super(const AsyncValue.data(null));

  final RequestRepository _repository;

  Future<void> submit({
    required String customerId,
    required String providerId,
    required String categoryId,
    required String title,
    required String description,
    required String city,
    double? latitude,
    double? longitude,
  }) async {
    state = const AsyncValue.loading();
    try {
      final req = await _repository.createRequest(
        customerId: customerId,
        providerId: providerId,
        categoryId: categoryId,
        title: title,
        description: description,
        city: city,
        latitude: latitude,
        longitude: longitude,
      );
      state = AsyncValue.data(req);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// مزوّد متحكّم الطلب.
final requestControllerProvider =
    StateNotifierProvider<RequestController, AsyncValue<ServiceRequest?>>((ref) {
  return RequestController(ref.watch(requestRepositoryProvider));
});
