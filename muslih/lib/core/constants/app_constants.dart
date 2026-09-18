/// ثوابت التطبيق الأساسية (الألوان، النصوص، المفاتيح).
class AppConstants {
  const AppConstants._();

  /// اسم التطبيق المعروض في الواجهة.
  static const String appName = 'مُصلح';

  /// مدة افتراضية لانتهاء صلاحية الجلسة (بالدقائق).
  static const int sessionTimeoutMinutes = 60 * 24 * 7;

  /// عدد العناصر في كل صفحة عند التصفح (Pagination).
  static const int pageSize = 20;
}
