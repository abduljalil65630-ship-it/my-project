/// ملف إعداد البيئة (Environment).
///
/// ⚠️ بدّل القيم أدناه بمفاتيح مشروعك الحقيقي من لوحة Supabase:
///   Project Settings → API → Project URL & anon public key
/// لا تشارك مفتاح `service_role` أبداً في تطبيق العميل.
class Env {
  const Env._();

  /// رابط مشروع Supabase (يبدأ بـ https://...).
  static const String supabaseUrl = 'https://xkvqkdkbppvjphectflt.supabase.co';

  /// المفتاح العام (anon) — آمن للمشاركة في تطبيق العميل.
  /// ⚠️ المفتاح الحالي 'sb_publishable_...' ليس بتنسيق anon القياسي (eyJ...).
  /// استبدله بالمفتاح 'anon public' من Project Settings → API.
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhrdnFrZGticHB2anBoZWN0Zmx0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4ODExMjkyMCwiZXhwIjoyMTAzNjg4OTIwfQ.t0yBTKin07exNw1RPD3qCXX8xPtuLA2lrQ-3waf_qac';
}
