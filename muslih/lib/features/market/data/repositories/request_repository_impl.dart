import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:muslih/features/market/domain/entities/provider.dart';
import 'package:muslih/features/market/domain/repositories/request_repository.dart';
import 'package:muslih/features/market/data/models/service_request_model.dart';

class RequestRepositoryImpl implements RequestRepository {
  final SupabaseClient _client;
  RequestRepositoryImpl(this._client);

  @override
  Future<ServiceRequest> createRequest({
    double? latitude,
    double? longitude,
    required String customerId,
    required String providerId,
    required String categoryId,
    required String title,
    required String description,
    required String city,
  }) async {
    final model = ServiceRequestModel(
      id: '',
      customerId: customerId,
      providerId: providerId,
      categoryId: categoryId,
      title: title,
      description: description,
      city: city,
      latitude: latitude,
      longitude: longitude,
      status: 'pending',
      createdAt: DateTime.now().toIso8601String(),
    );
    
    final row = await _client
        .from('service_requests')
        .insert(model.toInsertJson())
        .select()
        .single();
        
    return ServiceRequestModel.fromJson(row).toEntity();
  }

  @override
  Future<List<ServiceRequest>> getCustomerRequests(String customerId) async {
    final rows = await _client
        .from('service_requests')
        .select()
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);
        
    return (rows as List)
        .map((e) => ServiceRequestModel.fromJson(e).toEntity())
        .toList();
  }

  @override
  Future<List<ServiceRequest>> getProviderRequests(String providerId) async {
    final rows = await _client
        .from('service_requests')
        .select()
        .eq('provider_id', providerId)
        .order('created_at', ascending: false);

    return (rows as List)
        .map((e) => ServiceRequestModel.fromJson(e).toEntity())
        .toList();
  }

  @override
  Future<void> updateRequestStatus(String requestId, RequestStatus status) async {
    await _client
        .from('service_requests')
        .update({'status': status.value})
        .eq('id', requestId);
  }
}
