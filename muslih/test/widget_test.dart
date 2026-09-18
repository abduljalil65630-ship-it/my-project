// اختبار دخان بسيط لتطبيق مُصلح.
// ملاحظة: الاختبارات الكاملة تتطلب تهيئة Supabase؛ هذا الاختبار يتحقق فقط من
// صحة بناء الملفات (compilation) عبر استيراد main.

import 'package:flutter_test/flutter_test.dart';

import 'package:muslih/main.dart' as app;

void main() {
  test('main entry exists', () {
    // يتحقق من أن نقطة الدخول معرّفة (وليست MyApp القديمة).
    expect(app.main, isA<Function>());
  });
}
