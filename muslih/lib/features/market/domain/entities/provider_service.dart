class ProviderService {
  final String id;
  final String providerId;
  final String name;
  final String? description;
  final double? price;

  const ProviderService({
    required this.id,
    required this.providerId,
    required this.name,
    this.description,
    this.price,
  });
}