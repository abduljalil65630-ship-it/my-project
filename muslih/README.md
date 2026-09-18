# مُصلح — Muslih

> منصة لربط العملاء بمزودي الخدمات المنزلية الموثوقين (سباكة، كهرباء، نجارة، وكل خدمات المنزل).

تطبيق فلاتر احترافي بهيكلية **Clean Architecture + Riverpod + Supabase**، يدعم أندرويد و iOS.

---

## ✨ الميزات
- 🔐 مصادقة كاملة (تسجيل / دخول / خروج) عبر Supabase
- 🏠 **كل خدمات المنزل** (15 فئة: سباكة، كهرباء، نجارة، دهانات، تكييف، تنظيف، أجهزة، مكافحة حشرات، نقل، زجاج، حدائق، أقفال، أسطح، تغذية/إنترنت، صيانة عامة)
- 🔎 بحث وفرز المزودين حسب الفئة والمدينة والتقييم
- ⭐ تقييمات ووسم "موثّق" (Verified)
- 📝 طلب خدمة من العميل إلى المزوّد بخطوات بسيطة
- 🎨 واجهة عربية (Cairo) بثيم فاتح مريح

## 🧱 الهيكلية (Clean Architecture + Feature-first)
```
lib/
├── core/                 # مشترك: theme, errors, config, router, constants
├── features/
│   ├── auth/             # المصادقة: domain ↔ data ↔ presentation
│   ├── market/           # السوق: الفئات + المزودين + الطلبات
│   ├── profile/          # الحساب
│   └── splash/           # شاشة البداية
└── main.dart
```
كل ميزة مقسّمة إلى `domain` (entities + repositories) · `data` (models + impl) · `presentation` (pages + providers).

## 🚀 التشغيل
1. **متطلبات:** Flutter 3.22+ و Dart 3.4+.
2. أنشئ مشروعاً على [(https://supabase.com) وانسخ `URL` و `anon key`.
3. بدّل القيم في `lib/core/config/env.dart`:
   ```dart
   static const String supabaseUrl = 'https://YOUR-PROJECT.supabase.co';
   static const String supabaseAnonKey = 'YOUR-ANON-KEY';
   ```
4. شغّل مخطط قاعدة البيانات: افتح `supabase/schema.sql` في SQL Editor بلوحة Supabase ونفّذه.
5. نزّل الحزم وشغّل:
   ```bash
   flutter pub get
   flutter run
   ```

## 🗄 البيانات
- الجداول: `categories`, `profiles`, `providers`, `service_requests`, `reviews`
- سياسات أمان (RLS) جاهزة، مع دالة لتحديث تقييم المزوّد تلقائياً.

## 📌 ملاحظات
- التسجيل يستخدم رقم الهاتف مُحوّلاً إلى بريد وهمي لأن Supabase Auth يعتمد البريد افتراضياً.
  للإنتاج يُنصح بالتبديل إلى **OTP عبر SMS** (تفعيل Phone Auth في Supabase).
- ميزة المحادثة الداخلية وإشعارات Realtime مُخطّط لها كمرحلة تالية.

---
بُني بهيكلية قابلة للتوسّع: إضافة فئة خدمة = سطر واحد فقط في `ServiceCategories.all`.
