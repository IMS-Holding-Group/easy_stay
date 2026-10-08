# EasyStay - تطبيق حجز الفنادق

## شرح الفكرة

EasyStay هو تطبيق أندرويد مبني باستخدام Flutter وDart لإدارة حجوزات الفنادق. يتيح التطبيق للمستخدمين التسجيل، تسجيل الدخول، وعرض الغرف المتاحة وحجزها. يتم حفظ جميع البيانات محلياً باستخدام SQLite.

## هيكل المجلدات

```
easy_stay/
├── lib/
│   ├── main.dart                    # نقطة الدخول الرئيسية للتطبيق
│   ├── models/                      # نماذج البيانات
│   │   ├── user.dart               # نموذج المستخدم
│   │   ├── room.dart               # نموذج الغرفة
│   │   └── booking.dart            # نموذج الحجز
│   ├── screens/                     # شاشات التطبيق
│   │   ├── register_screen.dart    # شاشة التسجيل
│   │   ├── login_screen.dart       # شاشة تسجيل الدخول
│   │   └── rooms_screen.dart       # شاشة عرض الغرف والحجز
│   └── services/                    # خدمات قاعدة البيانات
│       └── db_service.dart          # خدمة SQLite
├── assets/
│   ├── fonts/                       # خطوط IBM Plex Sans Arabic
│   └── images/                      # صور الغرف (اختياري)
├── android/                         # إعدادات أندرويد
├── pubspec.yaml                     # ملف التبعيات والإعدادات
└── README.md                        # هذا الملف
```

## خطوات تشغيل المشروع محلياً على Windows

### 1. تثبيت Flutter SDK

1. قم بتحميل Flutter SDK من الموقع الرسمي:
   - [صفحة تثبيت Flutter](https://docs.flutter.dev/install)
   - [دليل البدء السريع](https://docs.flutter.dev/get-started)
   - [التثبيت اليدوي](https://docs.flutter.dev/install/manual)

2. استخرج ملف ZIP في مجلد مناسب (مثلاً: `C:\src\flutter`)

3. أضف Flutter إلى متغيرات البيئة PATH:
   - افتح "متغيرات البيئة" من لوحة التحكم
   - أضف المسار `C:\src\flutter\bin` إلى متغير PATH
   - أو استخدم PowerShell كمسؤول وقم بتنفيذ:
     ```powershell
     [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
     ```

4. تحقق من التثبيت:
   ```bash
   flutter doctor
   ```

### 2. تثبيت Android Studio أو VS Code

#### خيار 1: استخدام VS Code (موصى به)

1. قم بتحميل وتثبيت VS Code من [الموقع الرسمي](https://code.visualstudio.com/)

2. افتح VS Code وقم بتثبيت الإضافات التالية:
   - **Flutter** (من Google)
   - **Dart** (من Google)

3. اتبع دليل التثبيت:
   - [استخدام VS Code مع Flutter](https://docs.flutter.dev/install/with-vs-code)

#### خيار 2: استخدام Android Studio

1. قم بتحميل وتثبيت Android Studio من الموقع الرسمي
2. قم بتثبيت Flutter و Dart plugins من خلال Settings > Plugins

### 3. إعداد محاكي Android (إن لم يكن لديك جهاز)

1. افتح Android Studio
2. انتقل إلى Tools > Device Manager
3. أنشئ محاكي Android جديد (AVD)
4. اختر جهاز ونسخة Android (موصى به: Android 10 أو أحدث)

### 4. تشغيل المشروع

1. افتح VS Code أو Android Studio

2. افتح مجلد المشروع:
   ```
   C:\Users\TRSI\VSCode\Projects\flutterprojects\easy_stay
   ```

3. افتح Terminal في VS Code (Terminal > New Terminal) أو استخدم Command Prompt/PowerShell

4. قم بتثبيت التبعيات:
   ```bash
   flutter pub get
   ```

5. تحقق من الأجهزة المتاحة:
   ```bash
   flutter devices
   ```

6. شغّل التطبيق:
   ```bash
   flutter run
   ```

   أو حدد جهازاً محدداً:
   ```bash
   flutter run -d <device-id>
   ```

### 5. اختبار سريع (Test Drive)

- [دليل البدء السريع والتحقق](https://docs.flutter.dev/get-started/quick)

## كيفية بناء APK

لإنشاء ملف APK للتطبيق:

1. تأكد من أنك في مجلد المشروع:
   ```bash
   cd C:\Users\TRSI\VSCode\Projects\flutterprojects\easy_stay
   ```

2. قم ببناء APK:
   ```bash
   flutter build apk
   ```

3. سيكون ملف APK موجوداً في:
   ```
   build\app\outputs\flutter-apk\app-release.apk
   ```

لإنشاء APK محسّن للحجم:
```bash
flutter build apk --split-per-abi
```

## اختبار القبول (Acceptance Tests)

### خطوات التحقق السريعة:

1. **افتح المشروع في VS Code:**
   - افتح المجلد `C:\Users\TRSI\VSCode\Projects\flutterprojects\easy_stay`

2. **قم بتثبيت التبعيات:**
   ```bash
   flutter pub get
   ```

3. **شغّل التطبيق على محاكي Android:**
   ```bash
   flutter run
   ```

4. **اختبر التدفق الكامل:**
   - سجّل مستخدماً جديداً من شاشة التسجيل (أدخل اسم، إيميل، رقم جوال، كلمة مرور)
   - سجّل الدخول باستخدام الإيميل وكلمة المرور
   - انتقل إلى شاشة الغرف
   - احجز غرفة بالنقر على زر "احجز الآن"
   - تأكد من ظهور رسالة نجاح الحجز

5. **التحقق من البيانات في قاعدة البيانات:**
   - بعد الحجز، افتح Console في VS Code أو Terminal
   - ستجد رسائل مطبوعة تحتوي على تفاصيل الحجوزات:
     ```
     === Bookings for User ID X ===
     Booking ID: Y, Room ID: Z, Date: ...
     ```
   - يمكنك أيضاً إضافة وظيفة داخل التطبيق لعرض جميع الحجوزات (اختياري)

## الروابط الرسمية

- [صفحة تثبيت Flutter](https://docs.flutter.dev/install)
- [دليل البدء مع Flutter](https://docs.flutter.dev/get-started)
- [التثبيت اليدوي لـ Flutter](https://docs.flutter.dev/install/manual)
- [استخدام VS Code مع Flutter](https://docs.flutter.dev/install/with-vs-code)
- [دليل البدء السريع والتحقق](https://docs.flutter.dev/get-started/quick)

## ملاحظات تقنية

- التطبيق يستخدم SQLite محلياً لحفظ البيانات
- كلمات المرور تُحفظ كنص بسيط (لأغراض تعليمية فقط - في الإنتاج يجب تشفيرها)
- الخط المستخدم: IBM Plex Sans Arabic
- جميع البيانات محلية ولا تتطلب اتصال بالإنترنت
