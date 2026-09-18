import 'package:muslih/features/market/domain/entities/provider.dart';

/// نموذج طلب الخدمة المعياري (JSON ↔ Entity).
class ServiceRequestModel {
  final String id;
  final String customerId;
  final String providerId;
  final String categoryId;
  final String title;
  final String description;
  final String city;
  final double? latitude;
  final double? longitude;
  final String status;
  final String createdAt;

  const ServiceRequestModel({
    required this.id,
    required this.customerId,
    required this.providerId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.city,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      ServiceRequestModel(
        id: json['id'] as String,
        customerId: json['customer_id'] as String,
        providerId: json['provider_id'] as String,
        categoryId: json['category_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        city: json['city'] as String,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        status: (json['status'] as String?) ?? 'pending',
        createdAt: json['created_at'] as String,
      );

  Map<String, dynamic> toInsertJson() => {
        'customer_id': customerId,
        'provider_id': providerId,
        'category_id': categoryId,
        'title': title,
        'description': description,
        'city': city,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
      };

  ServiceRequest toEntity() => ServiceRequest(
        id: id,
        customerId: customerId,
        providerId: providerId,
        categoryId: categoryId,
        title: title,
        description: description,
        city: city,
        latitude: latitude,
        longitude: longitude,
        status: RequestStatus.fromValue(status),
        createdAt: DateTime.parse(createdAt),
      );
}
