import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// فئة خدمة منزلية (مثل: سباكة، كهرباء، نجارة...).
class ServiceCategory extends Equatable {
  final String id;
  final String name;
  final String? iconName;
  final String? description;

  const ServiceCategory({
    required this.id,
    required this.name,
    this.iconName,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, iconName, description];
}

/// قائمة الفئات الثابتة لكل خدمات المنزل (تُعرض في الواجهة الرئيسية).
///
/// هذه هي "كل الخدمات" التي طلبها المستخدم — تغطي الخدمات المنزلية الشائعة.
class ServiceCategories {
  const ServiceCategories._();

  static const List<ServiceCategory> all = [
    ServiceCategory(id: 'plumbing', name: 'سباكة', iconName: 'plumbing'),
    ServiceCategory(id: 'electrical', name: 'كهرباء', iconName: 'electrical'),
    ServiceCategory(id: 'carpentry', name: 'نجارة', iconName: 'carpentry'),
    ServiceCategory(id: 'painting', name: 'دهانات', iconName: 'painting'),
    ServiceCategory(id: 'ac', name: 'تكييف وتبريد', iconName: 'ac'),
    ServiceCategory(id: 'cleaning', name: 'تنظيف', iconName: 'cleaning'),
    ServiceCategory(id: 'appliances', name: 'أجهزة منزلية', iconName: 'appliances'),
    ServiceCategory(id: 'pest', name: 'مكافحة حشرات', iconName: 'pest'),
    ServiceCategory(id: 'moving', name: 'نقل وأثاث', iconName: 'moving'),
    ServiceCategory(id: 'glass', name: 'زجاج وألمنيوم', iconName: 'glass'),
    ServiceCategory(id: 'gardening', name: 'حدائق وتنسيق', iconName: 'gardening'),
    ServiceCategory(id: 'locks', name: 'أقفال وإنقاذ', iconName: 'locks'),
    ServiceCategory(id: 'roofing', name: 'أسطح وعزل', iconName: 'roofing'),
    ServiceCategory(id: 'satellite', name: 'تغذية وإنترنت', iconName: 'satellite'),
    ServiceCategory(id: 'general', name: 'صيانة عامة', iconName: 'general'),
  ];

  /// تحويل اسم الأيقونة إلى أيقونة فلاتر الفعلية.
  static IconData iconFor(String? iconName) {
    switch (iconName) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'carpentry':
        return Icons.carpenter;
      case 'painting':
        return Icons.format_paint;
      case 'ac':
        return Icons.ac_unit;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'appliances':
        return Icons.kitchen;
      case 'pest':
        return Icons.bug_report;
      case 'moving':
        return Icons.local_shipping;
      case 'glass':
        return Icons.window;
      case 'gardening':
        return Icons.yard;
      case 'locks':
        return Icons.vpn_key;
      case 'roofing':
        return Icons.roofing;
      case 'satellite':
        return Icons.satellite_alt;
      case 'general':
      default:
        return Icons.build;
    }
  }
}
