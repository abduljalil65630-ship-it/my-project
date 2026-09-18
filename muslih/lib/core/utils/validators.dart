  /// دوال تحقق من صحة المدخلات (Validation).
class Validators {
  const Validators._();

  static String? required(String? value, [String field = 'هذا الحقل']) {
    if (value == null || value.trim().isEmpty) {
      return '$field مطلوب';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم الهاتف مطلوب';
    }
    // يقبل أرقاماً تبدأ بـ 0 أو + ومكونة من 9 إلى 15 رقماً.
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^(\+?\d{9,15})$').hasMatch(cleaned)) {
      return 'رقم هاتف غير صالح';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.length < 8) {
      return 'كلمة المرور يجب ألا تقل عن 8 أحرف';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null; // اختياري
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'بريد إلكتروني غير صالح';
    }
    return null;
  }
}
