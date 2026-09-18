import 'package:muslih/features/market/domain/entities/provider.dart';

/// عقد إنشاء طلب خدمة من العميل إلى المزوّد.
abstract class RequestRepository {
  /// إنشاء طلب خدمة جديد.
  Future<ServiceRequest> createRequest({
    required String customerId,
    required String providerId,
    required String categoryId,
    required String title,
    required String description,
    required String city,
    double? latitude,
    double? longitude,
  });

  /// طلبات العميل الحالية.
  Future<List<ServiceRequest>> getCustomerRequests(String customerId);

  /// الطلبات الواردة للمزود.
  Future<List<ServiceRequest>> getProviderRequests(String providerId);

  /// تحديث حالة الطلب (قبول/رفض/إكمال).
  Future<void> updateRequestStatus(String requestId, RequestStatus status);
}
