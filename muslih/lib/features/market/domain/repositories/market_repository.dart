import 'package:muslih/features/market/domain/entities/provider.dart';
import 'package:muslih/features/market/domain/entities/service_category.dart';
import 'package:muslih/features/market/domain/entities/provider_service.dart';

abstract class MarketRepository {
  Future<List<ServiceProvider>> getProviders({
    String? categoryId,
    String? city,
  });

  Future<ServiceProvider> getProviderById(String id);

  Future<List<ServiceProvider>> searchProviders(String query);

  Future<List<ProviderService>> getProviderServices(String providerId);

  Future<void> addProviderService({
    required String providerId,
    required String name,
    String? description,
    double? price,
  });

  Future<void> deleteProviderService(String serviceId);
}