# What2Eat — Branding Concepts

Brand for Iranian Cafe Bazaar: AI cooking assistant with warm spice identity (orange + burgundy + cream), RTL-first, appetite-led.

## Logo & Icon — 3 Concepts

### Concept A — «هوش در قابلمه» (Spark Pot)
A rounded cooking pot silhouette with a small AI spark (✦) rising as steam.

- **Why it works:** Instantly reads as cooking; spark = AI without looking like ChatGPT.
- **Usage:** App icon (filled orange pot on cream), splash mark, store listing.
- **Palette:** Pot `#E85D04`, spark `#9B2226`, background `#FFF8F0`.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 108" fill="none">
  <rect width="108" height="108" rx="24" fill="#FFF8F0"/>
  <path d="M28 48h52c2 0 4 2 4 4v28c0 10-8 18-18 18H42c-10 0-18-8-18-18V52c0-2 2-4 4-4z" fill="#E85D04"/>
  <path d="M34 48V42c0-8 6-14 14-14h12c8 0 14 6 14 14v6" stroke="#9B2226" stroke-width="4" stroke-linecap="round"/>
  <path d="M54 18l2.2 6.5H63l-5.4 4 2.2 6.5L54 31l-5.8 4 2.2-6.5-5.4-4h6.8L54 18z" fill="#9B2226"/>
</svg>
```

### Concept B — «قاشق هوشمند» (Neural Spoon)
A spoon whose bowl contains a subtle node/network mark (3 dots + arcs).

- **Why it works:** Kitchen tool + “intelligence” metaphor; scales cleanly to 48px.
- **Usage:** Monochrome for status bar / adaptive icons; orange fill for marketing.
- **Palette:** Spoon `#E85D04`, nodes `#FFF8F0` on `#9B2226` badge.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 108" fill="none">
  <rect width="108" height="108" rx="24" fill="#1C1412"/>
  <path d="M52 78V42c0-12 8-20 18-20s18 8 18 20-8 20-18 20h-6v16c0 6-4 10-10 10s-10-4-10-10z" fill="#E85D04"/>
  <circle cx="70" cy="36" r="3.5" fill="#FFF8F0"/>
  <circle cx="62" cy="44" r="3.5" fill="#FFF8F0"/>
  <circle cx="78" cy="44" r="3.5" fill="#FFF8F0"/>
  <path d="M70 36l-6 6M70 36l8 8M62 44h16" stroke="#FFF8F0" stroke-width="1.5" opacity="0.7"/>
</svg>
```

### Concept C — «چرخ طعم» (Flavor Orbit)
A circular badge with a fork/knife glyph orbited by a thin AI arc (progress/ring).

- **Why it works:** Feels modern Material 3 / store-ready; ring = “generating”.
- **Usage:** Preferred for Cafe Bazaar feature graphic + generate CTA iconography.
- **Palette:** Ring `#F48C06`, glyph `#9B2226`, field `#FFF8F0`.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 108" fill="none">
  <rect width="108" height="108" rx="24" fill="#FFF8F0"/>
  <circle cx="54" cy="54" r="34" stroke="#F48C06" stroke-width="6" stroke-dasharray="160 50" stroke-linecap="round"/>
  <path d="M44 36v36M44 36c6 0 10 4 10 12v8c0 6-4 10-10 10M64 36v36M64 36c0 8 4 12 8 12" stroke="#9B2226" stroke-width="5" stroke-linecap="round"/>
</svg>
```

**Recommendation:** Ship **Concept A** as primary app icon; reuse Concept C’s orbit motif on the Generate tab / loading states.

---

## Wordmark

- Persian: **چیزی‌بخور** / product name as localized in app (`appNamePersian`)
- Latin: **What2Eat**
- Type: **Vazirmatn SemiBold** for Persian lockup; never mix Latin digits in Persian lockups (use UI-FD).

---

## Cafe Bazaar Store Assets Guide

### Feature Graphic (بنر اصلی)
- Size: follow current Cafe Bazaar feature graphic spec (typically wide banner).
- Composition:
  1. Right (RTL start): wordmark + one short value prop («دستور پخت با هوش مصنوعی»).
  2. Left: 1–2 phone mockups showing **Generate** + **Recipe Detail**.
  3. Background: cream → soft orange gradient; avoid busy food photography collage.
- Do **not** crowd with stats, badges, or long paragraphs.

### Phone Screenshots (اسکرین‌شات‌های تبلیغاتی) — highlight these
| Frame | Screen | Highlight |
| --- | --- | --- |
| 1 | تولید دستور | Chip selection + big orange CTA «تولید دستور» |
| 2 | جزئیات دستور | Ingredients with Persian digits + numbered steps |
| 3 | لیست دستورها | Search + readable card hierarchy |
| 4 | علاقه‌مندی‌ها | Heart states / personal collection |
| 5 | ورود / OTP | Trust & simplicity (clean auth) |

### Caption tips (Persian)
- Lead with benefit: «با مواد داخل یخچال، دستور بساز»
- Mention AI once, cooking twice
- Show Persian digits in every crop that includes numbers

### Icon export
- Export Concept A at 512×512 PNG with 20% safe padding
- Adaptive: cream background layer + orange pot foreground

---

## Motion & Micro-interactions (in app)
- Chip select: light `AnimatedScale` (~1.02)
- Favorite: `AnimatedSwitcher` heart cross-fade
- Splash / login: soft circular brand container (no heavy blur)

Keep effects cheap for mid-range Android devices common on Cafe Bazaar.
