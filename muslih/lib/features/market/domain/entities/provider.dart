import 'package:equatable/equatable.dart';

/// مزوّد خدمة (حرفي/فني) معروض في السوق.
class ServiceProvider extends Equatable {
  final String id;
  final String fullName;
  final String categoryId;
  final String categoryName;
  final String? bio;
  final String? city;
  final double rating;
  final int reviewCount;
  final int completedJobs;
  final double? hourlyRate;
  final String? avatarUrl;
  final bool isVerified;

  const ServiceProvider({
    required this.id,
    required this.fullName,
    required this.categoryId,
    required this.categoryName,
    this.bio,
    this.city,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    this.hourlyRate,
    this.avatarUrl,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        categoryId,
        categoryName,
        bio,
        city,
        rating,
        reviewCount,
        completedJobs,
        hourlyRate,
        avatarUrl,
        isVerified,
      ];
}

/// طلب خدمة يقدّمه العميل لمزوّد.
class ServiceRequest extends Equatable {
  final String id;
  final String customerId;
  final String providerId;
  final String categoryId;
  final String title;
  final String description;
  final String city;
  final double? latitude;
  final double? longitude;
  final RequestStatus status;
  final DateTime createdAt;

  const ServiceRequest({
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

  @override
  List<Object?> get props => [
        id,
        customerId,
        providerId,
        categoryId,
        title,
        description,
        city,
        latitude,
        longitude,
        status,
        createdAt,
      ];
}

/// حالة طلب الخدمة.
enum RequestStatus {
  pending('pending', 'بانتظار القبول'),
  accepted('accepted', 'مقبول'),
  rejected('rejected', 'مرفوض'),
  completed('completed', 'مكتمل');

  final String value;
  final String label;
  const RequestStatus(this.value, this.label);

  static RequestStatus fromValue(String? v) => RequestStatus.values
      .firstWhere((e) => e.value == v, orElse: () => RequestStatus.pending);
}

