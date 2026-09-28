# APP METADATA / SHARED CATALOG FEATURE - FitSho (اپ موبایل کاربر)

## هدف کلی
دریافت و کش کردن کاتالوگ متادیتای مشترک پلتفرم (عضلات، دسته‌بندی‌ها، تجهیزات و ...) از بک‌اند، با استراتژی versioning برای بروزرسانی خودکار در پس‌زمینه. اگر دسترسی به اینترنت وجود نداشت، از مقادیر ثابت hardcode شده داخل اپ استفاده شود (Graceful Fallback).

## استراتژی کش و بروزرسانی

```
اپ باز می‌شود
  ↓
بررسی کش محلی (Hive_ce - metadata_box)
  ├─ کش وجود دارد → نمایش فوری کش به UI
  └─ کش ندارد → نمایش مقادیر Fallback به UI
  ↓
در پس‌زمینه: GET /api/v1/metadata/version
  ├─ نسخه جدید == نسخه کش → هیچ‌کاری نکن
  └─ نسخه جدید > نسخه کش → GET /api/v1/metadata
        ↓
      ذخیره در کش Hive + notify providers
```

## Graceful Fallback
اگر API در دسترس نبود یا خطا داد، از فایل `lib/core/metadata/default_catalog.dart` استفاده می‌شود که مقادیر پیش‌فرض را به صورت hardcode نگه می‌دارد. این فایل باید همیشه sync با مقادیر seed بک‌اند باشد.

## Force Update (در صورت نیاز)
اگر ساختار داده به شکلی تغییر کرد که نسخه قدیمی اپ نمی‌تواند آن را parse کند، بک‌اند یک فیلد `minAppVersion` در response اضافه می‌کند. اپ این مقدار را با نسخه خودش مقایسه می‌کند؛ اگر قدیمی‌تر بود، یک dialog اجباری برای آپدیت نمایش می‌دهد و اپ را قفل می‌کند.

---

## فازهای توسعه

### Phase 1: Default Catalog (Fallback Values) (✅ Done)
**هدف:** ایجاد فایل مقادیر ثابت به عنوان fallback در صورت نبود اینترنت.

**تسک‌ها:**

1. ایجاد `lib/core/metadata/default_catalog.dart`:
```dart
class DefaultCatalog {
  static const Map<String, List<Map<String, String>>> catalog = {
    'muscle_group': [
      {'key': 'chest', 'labelFa': 'سینه', 'labelEn': 'Chest'},
      {'key': 'back', 'labelFa': 'پشت', 'labelEn': 'Back'},
      {'key': 'legs', 'labelFa': 'پا', 'labelEn': 'Legs'},
      {'key': 'arms', 'labelFa': 'بازو', 'labelEn': 'Arms'},
      {'key': 'shoulders', 'labelFa': 'سرشانه', 'labelEn': 'Shoulders'},
      {'key': 'core', 'labelFa': 'شکم و مرکزی', 'labelEn': 'Core'},
      {'key': 'glutes', 'labelFa': 'سرین', 'labelEn': 'Glutes'},
      {'key': 'full_body', 'labelFa': 'کل بدن', 'labelEn': 'Full Body'},
    ],
    'exercise_category': [
      {'key': 'strength', 'labelFa': 'قدرتی', 'labelEn': 'Strength'},
      {'key': 'cardio', 'labelFa': 'هوازی', 'labelEn': 'Cardio'},
      {'key': 'flexibility', 'labelFa': 'انعطاف‌پذیری', 'labelEn': 'Flexibility'},
      {'key': 'mobility', 'labelFa': 'تحرک‌پذیری', 'labelEn': 'Mobility'},
    ],
    'movement_pattern': [
      {'key': 'push', 'labelFa': 'فشاری', 'labelEn': 'Push'},
      {'key': 'pull', 'labelFa': 'کششی', 'labelEn': 'Pull'},
      {'key': 'squat', 'labelFa': 'اسکات', 'labelEn': 'Squat'},
      {'key': 'hinge', 'labelFa': 'لولایی', 'labelEn': 'Hinge'},
      {'key': 'lunge', 'labelFa': 'لانج', 'labelEn': 'Lunge'},
      {'key': 'core', 'labelFa': 'مرکزی', 'labelEn': 'Core'},
      {'key': 'carry', 'labelFa': 'حمل', 'labelEn': 'Carry'},
    ],
    'equipment': [
      {'key': 'bodyweight', 'labelFa': 'وزن بدن', 'labelEn': 'Bodyweight'},
      {'key': 'dumbbell', 'labelFa': 'دمبل', 'labelEn': 'Dumbbell'},
      {'key': 'barbell', 'labelFa': 'هالتر', 'labelEn': 'Barbell'},
      {'key': 'cable', 'labelFa': 'کابل', 'labelEn': 'Cable'},
      {'key': 'resistance_band', 'labelFa': 'کش ورزشی', 'labelEn': 'Resistance Band'},
      {'key': 'machine', 'labelFa': 'دستگاه', 'labelEn': 'Machine'},
      {'key': 'kettlebell', 'labelFa': 'کتل‌بل', 'labelEn': 'Kettlebell'},
    ],
    'workout_type': [
      {'key': 'strength_training', 'labelFa': 'تمرین قدرتی', 'labelEn': 'Strength Training'},
      {'key': 'HIIT', 'labelFa': 'هیت', 'labelEn': 'HIIT'},
      {'key': 'circuit', 'labelFa': 'سرکیت', 'labelEn': 'Circuit'},
      {'key': 'endurance', 'labelFa': 'استقامتی', 'labelEn': 'Endurance'},
    ],
    'injury_type': [
      {'key': 'knee', 'labelFa': 'زانو', 'labelEn': 'Knee'},
      {'key': 'shoulder', 'labelFa': 'شانه', 'labelEn': 'Shoulder'},
      {'key': 'lower_back', 'labelFa': 'کمر پایین', 'labelEn': 'Lower Back'},
      {'key': 'upper_back', 'labelFa': 'کمر بالا', 'labelEn': 'Upper Back'},
      {'key': 'ankle', 'labelFa': 'مچ پا', 'labelEn': 'Ankle'},
      {'key': 'wrist', 'labelFa': 'مچ دست', 'labelEn': 'Wrist'},
    ],
    'goal': [
      {'key': 'weight_loss', 'labelFa': 'کاهش وزن', 'labelEn': 'Weight Loss'},
      {'key': 'muscle_gain', 'labelFa': 'عضله‌سازی', 'labelEn': 'Muscle Gain'},
      {'key': 'endurance', 'labelFa': 'استقامت', 'labelEn': 'Endurance'},
      {'key': 'flexibility', 'labelFa': 'انعطاف', 'labelEn': 'Flexibility'},
      {'key': 'general_fitness', 'labelFa': 'تناسب اندام', 'labelEn': 'General Fitness'},
    ],
    'difficulty_level': [
      {'key': 'beginner', 'labelFa': 'مبتدی', 'labelEn': 'Beginner'},
      {'key': 'intermediate', 'labelFa': 'متوسط', 'labelEn': 'Intermediate'},
      {'key': 'advanced', 'labelFa': 'پیشرفته', 'labelEn': 'Advanced'},
      {'key': 'elite', 'labelFa': 'حرفه‌ای', 'labelEn': 'Elite'},
    ],
  };
}
```

**Commit Message:** `feat(metadata): add default catalog fallback values`

---

### Phase 2: Domain & Data Layer (✅ Done)
**هدف:** پیاده‌سازی entity، repository و data model.

**تسک‌ها:**

1. ایجاد `lib/core/metadata/domain/entities/metadata_item.dart`:
```dart
class MetadataItem {
  final String key;
  final String labelFa;
  final String labelEn;
  final String? icon;
  final int order;
}
```

2. ایجاد `lib/core/metadata/domain/entities/metadata_catalog.dart`:
```dart
class MetadataCatalog {
  final int version;
  final DateTime updatedAt;
  final Map<String, List<MetadataItem>> catalog;

  // Helper methods
  List<MetadataItem> getByType(String type);
  MetadataItem? findByKey(String type, String key);
}
```

3. ایجاد `lib/core/metadata/domain/repositories/metadata_repository.dart` (abstract interface)

4. ایجاد `lib/core/metadata/data/models/metadata_item_model.dart` با `json_serializable`

5. ایجاد `lib/core/metadata/data/datasources/metadata_remote_datasource.dart`:
   - `checkVersion()` → GET /api/v1/metadata/version
   - `fetchCatalog()` → GET /api/v1/metadata

6. ایجاد `lib/core/metadata/data/datasources/metadata_local_datasource.dart`:
   - ذخیره/بارگذاری کاتالوگ و نسخه در دیتابیس `Hive_ce` (`metadata_box`)

7. ایجاد `lib/core/metadata/data/repositories/metadata_repository_impl.dart`:
   - منطق بررسی نسخه و تصمیم برای fetch یا استفاده از کش Hive_ce

8. اجرای `flutter pub run build_runner build --delete-conflicting-outputs`

**Commit Message:** `feat(metadata): implement metadata domain, data models and repository`

---

### Phase 3: Riverpod Provider & Background Sync
**هدف:** ایجاد provider سراسری برای دسترسی آسان به کاتالوگ در همه قسمت‌های اپ.

**تسک‌ها:**

1. ایجاد `lib/core/metadata/presentation/providers/metadata_provider.dart`:

```dart
final metadataCatalogProvider = StateNotifierProvider<MetadataNotifier, MetadataCatalog>(...);

final muscleGroupsProvider = Provider<List<MetadataItem>>((ref) =>
  ref.watch(metadataCatalogProvider).getByType('muscle_group'));

final equipmentProvider = Provider<List<MetadataItem>>((ref) =>
  ref.watch(metadataCatalogProvider).getByType('equipment'));
```

**MetadataNotifier:**
- در constructor: بارگذاری از کش Hive_ce یا fallback → نمایش فوری
- سپس: بررسی نسخه در background
- اگر نسخه جدید بود: fetch کامل و بروزرسانی state و کش Hive_ce
- متد `refresh()` برای refresh دستی

2. نوشتن unit test

**Commit Message:** `feat(metadata): implement metadata Riverpod provider with background sync`

---

### Phase 4: UI Integration
**هدف:** استفاده از provider در قسمت‌های مختلف اپ و مقادیر کاتالوگ.

**تسک‌ها:**

1. پیوند به گزینه‌های تمرینی و حرکات
2. بررسی سازگاری و تست ویجت

**Commit Message:** `feat(metadata): integrate metadata catalog into exercise and workout forms`

---

## وابستگی‌های جدید (pubspec.yaml)
نیاز به package جدید نیست. از `hive_ce_flutter` (موجود در پروژه) و `Riverpod` (موجود) استفاده می‌شود.

---
*پس از اتمام هر فاز، کامیت انجام و (✅ Done) جلوی نام فاز قرار گیرد.*
