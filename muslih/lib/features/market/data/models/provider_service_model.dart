import '../../domain/entities/provider_service.dart';

class ProviderServiceModel {
  final String id;
  final String providerId;
  final String name;
  final String? description;
  final double? price;

  const ProviderServiceModel({
    required this.id,
    required this.providerId,
    required this.name,
    this.description,
    this.price,
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceModel(
      id: json['id'],
      providerId: json['provider_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  ProviderService toEntity() => ProviderService(
    id: id,
    providerId: providerId,
    name: name,
    description: description,
    price: price,
  );
}