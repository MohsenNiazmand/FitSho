# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class plugins.flutter.io.**  { *; }

# جلوگیری از حذف کلاس‌های مدل داده (بسیار مهم برای دیتابیس محلی)
-keep class com.mnz.fitsho.models.** { *; }

# تنظیمات عمومی برای جلوگیری از خطاهای رایج
-dontwarn android.support.**
-dontwarn androidx.**

# ==========================================
# رفع خطای R8 برای کلاس‌های ناموجود گوگل پلی
# ==========================================
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**