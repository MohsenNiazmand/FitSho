# UI/UX Redesign — Final Checklist

## گام ۱ — Audit (یافته‌ها)

### بحرانی
- [x] فونت سیستم / خوانایی ضعیف فارسی → Vazirmatn UI-FD
- [x] اعداد لاتین در مقادیر مواد، زمان، موبایل → اعداد فارسی + فونت FD
- [x] کنتراست پایین متن راهنما روی پس‌زمینه روشن
- [x] کارت‌های لیست با padding تنگ و سلسله‌مراتب ضعیف عنوان

### متوسط
- [x] Spacing ناپایدار بین صفحات
- [x] radius/border ناهمگون بین Input / Button / Card
- [x] RTL: chevron جهت رفتن به جزئیات
- [x] Bottom nav / chips بدون هویت گرم برند
- [x] نبود Dark Theme

---

## گام ۲ — Design System

- [x] `lib/core/constants/colors.dart` — پالت گرم (نارنجی / زرشکی / کرم) + Dark
- [x] `lib/shared/presentation/widgets/gap.dart` — فاصله‌گذاری با `Gap`
- [x] `lib/config/theme/app_radius.dart` — شعاع گوشه‌های یکدست
- [x] `lib/config/theme/app_theme.dart` — ColorScheme کامل، TextTheme، Card/Input/Button/Nav/Chip
- [x] فونت `assets/fonts/Vazirmatn-UI-FD-*.ttf` در `pubspec.yaml`
- [x] کامپوننت‌های مشترک: `Gap`, `AppPrimaryButton`, `AppOutlinedButton`, `AppTextField`, `AppIconBadge`
- [x] Light theme فقط (`app.dart` بدون darkTheme)

---

## گام ۳ — صفحات بازنویسی‌شده

- [x] Splash
- [x] Login
- [x] OTP Verification
- [x] Recipe List + RecipeListTile
- [x] Recipe Detail content
- [x] Generate Recipe + chips + dynamic fields
- [x] Favorites + FavoriteListTile + FavoriteButton
- [x] Profile
- [x] Preferences
- [x] Empty / Error / Moderation shared widgets

---

## گام ۴ — برندینگ

- [x] `BRANDING.md` — ۳ کانسپت لوگو + راهنمای بنر کافه‌بازار
- [x] `assets/branding/logo_concept_a_spark_pot.svg`

---

## تایید دستی پیشنهادی

- [ ] اجرای اپ روی امولاتور / گوشی واقعی (RTL)
- [ ] بررسی Dark Mode سیستم
- [ ] چک اعداد فارسی در جزئیات دستور و پروفایل
- [ ] اسکرین‌شات‌های جدید برای استور پس از تایید بصری
