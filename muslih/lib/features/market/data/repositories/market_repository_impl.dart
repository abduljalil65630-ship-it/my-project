import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:muslih/core/errors/failures.dart';
import 'package:muslih/features/market/data/models/provider_model.dart';
import 'package:muslih/features/market/data/models/provider_service_model.dart';
import 'package:muslih/features/market/domain/entities/provider.dart';
import 'package:muslih/features/market/domain/entities/provider_service.dart';
import 'package:muslih/features/market/domain/repositories/market_repository.dart';

class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _select = '''
    id, full_name, category_id, bio, city, rating, review_count,
    completed_jobs, hourly_rate, avatar_url, is_verified,
    category:categories ( id, name )
  ''';

  @override
  Future<List<ServiceProvider>> getProviders({
    String? categoryId,
    String? city,
  }) async {
    try {
      dynamic query = _client.from('providers').select(_select);

      if (categoryId != null) {
        query = query.or('category_id.eq.${categoryId},category_id.eq.general');
      }

      if (city != null && city.isNotEmpty) {
        query = query.ilike('city', '%$city%');
      }

      final rows = await query.order('rating', ascending: false);

      return (rows as List)
          .map((e) => ProviderModel.fromJson(e).toEntity())
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<ServiceProvider> getProviderById(String id) async {
    try {
      final row = await _client
          .from('providers')
          .select(_select)
          .eq('id', id)
          .single();

      return ProviderModel.fromJson(row).toEntity();
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<ServiceProvider>> searchProviders(String query) async {
    final rows = await _client
        .from('providers')
        .select(_select)
        .or('full_name.ilike.%$query%,city.ilike.%$query%')
        .order('rating', ascending: false);

    return (rows as List)
        .map((e) => ProviderModel.fromJson(e).toEntity())
        .toList();
  }

  @override
  Future<List<ProviderService>> getProviderServices(
      String providerId) async {
    final rows = await _client
        .from('provider_services')
        .select()
        .eq('provider_id', providerId)
        .order('created_at');

    return (rows as List)
        .map((e) => ProviderServiceModel.fromJson(e).toEntity())
        .toList();
  }

  @override
  Future<void> addProviderService({
    required String providerId,
    required String name,
    String? description,
    double? price,
  }) async {
    await _client.from('provider_services').insert({
      'provider_id': providerId,
      'name': name,
      'description': description,
      'price': price,
    });
  }

  @override
  Future<void> deleteProviderService(String serviceId) async {
    await _client
        .from('provider_services')
        .delete()
        .eq('id', serviceId);
  }
}