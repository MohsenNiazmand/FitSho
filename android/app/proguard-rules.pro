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

# =============================================
# flutter_local_notifications — prevent R8 from
# stripping/obfuscating receiver internals
# =============================================
-keep class com.dexterous.** { *; }

# =============================================
# Gson — used by flutter_local_notifications
# for serializing notification data
# =============================================
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken