/// هرم الأخطاء (Failures) الموحّد في التطبيق.
///
/// كل الأخطاء التي تنتقل من طبقة البيانات إلى طبقة العرض
/// تُمثَّل بفئة من [Failure] لتبسيط المعالجة في الواجهة.
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  String toString() => message;
}

/// خطأ في الشبكة (لا إنترنت، مهلة، استجابة غير صحيحة).
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'تعذر الاتصال بالشبكة', super.code]);
}

/// خطأ في المصادقة (بيانات خاطئة، جلسة منتهية).
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'خطأ في تسجيل الدخول', super.code]);
}

/// خطأ في قاعدة البيانات أو الاستعلام.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'حدث خطأ في الخادم', super.code]);
}

/// خطأ في المدخلات (تحقق من صحة النموذج).
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'بيانات غير صحيحة', super.code]);
}

/// خطأ غير متوقع.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'حدث خطأ غير متوقع', super.code]);
}
