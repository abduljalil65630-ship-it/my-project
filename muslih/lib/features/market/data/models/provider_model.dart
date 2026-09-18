import 'package:muslih/features/market/domain/entities/provider.dart';

/// نموذج مزوّد الخدمة المعياري (JSON ↔ Entity).
///
/// يتطابق مع جدول `providers` في Supabase (منضمّاً مع جدول الفئات).
class ProviderModel {
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

  const ProviderModel({
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

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>?;
    return ProviderModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      categoryId: json['category_id'] as String? ?? category?['id'] ?? '',
      categoryName: category?['name'] as String? ?? 'عام',
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      rating: (json['rating'] as num? ?? 0).toDouble(),
      reviewCount: (json['review_count'] as num? ?? 0).toInt(),
      completedJobs: (json['completed_jobs'] as num? ?? 0).toInt(),
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      avatarUrl: json['avatar_url'] as String?,
      isVerified: (json['is_verified'] as bool? ?? false),
    );
  }

  ServiceProvider toEntity() => ServiceProvider(
        id: id,
        fullName: fullName,
        categoryId: categoryId,
        categoryName: categoryName,
        bio: bio,
        city: city,
        rating: rating,
        reviewCount: reviewCount,
        completedJobs: completedJobs,
        hourlyRate: hourlyRate,
        avatarUrl: avatarUrl,
        isVerified: isVerified,
      );
}
