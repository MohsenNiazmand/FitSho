# Workout Plan Improvements — Flutter Phases (FA1–FA6)

> **For AI agents / developers:** Read this whole file before touching code. Implement the phases in ascending order, test each phase before moving to the next, and tick its checklist. Never run `git commit` / `git push` yourself; report the English commit message of each phase and stop for review. Follow the existing Clean Architecture + Riverpod + hooks conventions and l10n (`app_fa.arb` / `app_en.arb`). The backend counterpart is `../fitsho-backend/WORKOUT_PLAN_IMPROVEMENTS.md`; the contract below must match it exactly.

## Why this work exists

Users report that for some bodybuilding programs the number of training days cannot be changed (e.g. bodybuilding + advanced → 5 days fixed). Analysis:

1. **Root cause is backend config.** The options API returns per-style `minDays`/`maxDays`; some styles have `minDays == maxDays` (`bro_split` 5–5, `upper_lower` 4–4, `phul` 4–4, `strength_5x5` 3–3). The app renders one chip per allowed day (`workout_profile_form.dart`, `_buildConditionsStep`), so a single chip appears. This is fixed by backend phase B12 and needs **no app update** (ranges come from `GET /workout-profile/options`).
2. **A real client-side UX bug makes it feel worse.** `daysPerWeek` (default 3) is clamped to the style range only when a saved profile loads. When the user changes style, level or discipline, the stale value remains (e.g. 3 while only a "5 days" chip exists). No chip looks selected and "Next" fails validation with a generic error.
3. **Smaller issues:** day chips are in a `Row` (can overflow with 5 options on small screens); changing the level can leave an invalid style selected silently; `elite` is hidden by a hard-coded filter while the backend is removing it.

## API contract (shared with backend)

`GET /api/v1/workout-profile/options`:
- `styles[]`: `id, disciplineId, label, description, minDays, maxDays, levels, isAvailable` plus **nullable `recommendedDays`** (new; absent on old backends → treat as null).
- `levels[]`: `beginner`, `intermediate`, `advanced` only (`elite` removed by backend B13).
- Everything else unchanged.

## Progress

| Phase | Title | Backend dependency | Status |
|-------|-------|--------------------|--------|
| FA1 | Single source of truth for allowed day range + auto-sync `daysPerWeek` | none | ☑ |
| FA2 | Day chips: `Wrap`, single-option hint | none | ☑ |
| FA3 | Reset incompatible style when level changes | none | ☑ |
| FA4 | `recommendedDays` badge | B12 (nullable, safe without it) | ☐ |
| FA5 | Remove `elite` handling | B13 | ☐ |
| FA6 | Tests, l10n, release notes | all | ☐ |

**Release order:** deploy the backend (B12–B13) first, then publish the app version containing these phases. Users on the current app version already get the new day ranges from the backend; FA1 fixes the stuck-validation behavior they may still see until they update.

---

## Phase FA1 — Allowed-day range helper and auto-sync

**Files:** `lib/features/workout/presentation/utils/workout_profile_validation.dart`, `presentation/widgets/workout_profile_form.dart`, `domain/entities/workout_entities.dart` (only if a small value type is needed).

**Changes**
- Add a pure function in `workout_profile_validation.dart`, e.g.
  `({int min, int max, int? recommended}) allowedWorkoutDaysRange({required WorkoutOptions options, required List<String> disciplines, required Map<String,String> styles, required String level})`.
  Rules: with exactly one discipline and a selected, available style that supports the level → the style's range and `recommendedDays`; otherwise `options.minDaysPerWeek..maxDaysPerWeek` and no recommendation.
- Use this helper in all three places that currently duplicate the logic: `_buildConditionsStep`, `isWorkoutProfileStepValid` (case 3) and the profile-load `useEffect` (clamp).
- Auto-sync: whenever `selectedStyles`, `selectedDisciplines` or `selectedLevel` changes, recompute the range and set `daysPerWeek.value` to:
  1. unchanged if still within range;
  2. else `recommended` if present;
  3. else `clamp(value, min, max)`.
  Implement with `useEffect` keyed on those notifiers, or inside the change handlers (preferred: deterministic and testable).
- Also clamp when the options load after the profile (existing `useEffect` dependency on `optionsAsync`).

**Tests** (`test/features/workout/presentation/utils/workout_profile_validation_test.dart`)
- Range helper: one discipline + `bro_split`; one discipline + `full_body`; two disciplines → global range; unavailable style/level → global range.
- Step-3 validity with the helper; stale value (3 with a 5-only style) is invalid, synced value valid.
- Auto-sync decision function (extract it as a pure function and test: in-range keeps, out-of-range → recommended, else clamp).

**Checklist**
- [x] Helper + all call sites use it
- [x] Auto-sync on style/level/discipline change
- [x] Tests green

**Commit message**
```
fix(workout): keep daysPerWeek in sync with the selected style range

daysPerWeek was only clamped when a saved profile loaded, so changing the
style or level left a stale value that matched no chip and blocked the
wizard. Extract allowedWorkoutDaysRange, reuse it in the form and the step
validator, and re-sync the value whenever discipline, style or level changes.
```

---

## Phase FA2 — Day chips layout and fixed-day hint

**Files:** `workout_profile_form.dart`, `lib/l10n/app_fa.arb`, `app_en.arb` (+ regenerate l10n).

**Changes**
- Replace the `Row` of day chips with `Wrap(spacing: 8, runSpacing: 8)` (the commented-out lines show the earlier intent).
- When `min == max`, show the single chip selected plus a small helper text, e.g. fa: «این سبک تمرینی فقط با {n} روز در هفته طراحی شده است»; en: "This style is designed for exactly {n} days per week."
- Keep chip styling (`0xFF6366F1` selected, `AppRadius.button`). Respect RTL and large font scales.

**Tests:** widget test rendering 5 chips at a narrow width (e.g. 320 px) and with text scale 1.5 without overflow; single-option case shows the hint.

**Checklist**
- [x] `Wrap` layout
- [x] Hint text + l10n keys (fa + en)
- [x] Widget tests green

**Commit message**
```
feat(workout): wrap day chips and explain fixed-day styles

Use a Wrap for the days-per-week chips so five options never overflow on
small screens, and show an explanatory hint when a style supports only
one day count.
```

---

## Phase FA3 — Reset incompatible style when the level changes

**Files:** `workout_profile_form.dart`, `workout_profile_validation.dart`, l10n files.

**Changes**
- Add a pure helper, e.g. `pruneStylesForLevel({options, styles, level})` returning the new map plus the list of removed discipline ids.
- On level change: apply the helper; if anything was removed, show a short toast/snackbar (fa: «سبک انتخاب‌شده برای این سطح مناسب نیست، لطفاً دوباره انتخاب کنید»). Then FA1 auto-sync runs.
- Keep the existing behavior that tapping the selected style clears it.

**Tests:** helper keeps valid styles, removes invalid ones, reports removed disciplines; a level change from `intermediate` to `beginner` removes `bro_split`.

**Checklist**
- [x] Helper + wiring + toast
- [x] Tests green

**Commit message**
```
fix(workout): clear styles that do not support the newly selected level

Changing the fitness level could leave an unsupported style selected and
fail validation without explanation. Prune incompatible styles on level
change and tell the user why.
```

---

## Phase FA4 — `recommendedDays` badge

**Files:** `data/models/workout_models.dart` (+ regenerate `workout_models.g.dart`), `data/mappers/workout_mappers.dart`, `domain/entities/workout_entities.dart` (`WorkoutStyle`), `workout_profile_form.dart`, l10n files.

**Changes**
- Add nullable `recommendedDays` to the style model/entity; parse defensively with the existing `_parseInt` helper; missing → null. Cached options in SharedPreferences must still deserialize (field optional).
- In the day chips, mark the recommended chip with a small badge/label («پیشنهادی» / "Recommended"). Do not auto-select it unless FA1's sync needs a fallback.
- Include the field in `toJson` for the options cache.

**Tests:** model parsing with and without the field; mapper; chip shows the badge only when the value is present and within range.

**Checklist**
- [ ] Model/entity/mapper updated, build_runner executed
- [ ] Badge UI + l10n
- [ ] Tests green

**Commit message**
```
feat(workout): highlight the recommended days per week for each style

Read the optional recommendedDays field from workout options and show a
"recommended" badge on the matching day chip. The field is nullable so the
app keeps working against backends that do not send it.
```

---

## Phase FA5 — Remove `elite` handling

**Files:** `workout_profile_form.dart` (line with `lvl.id != 'elite'`), `lib/core/metadata/default_catalog.dart` (`difficulty_level` entry), `APP_METADATA_FEATURE.md`, tests/fixtures mentioning `elite`.

**Changes**
- Delete the `elite` filter in the level selector (the API no longer returns it); delete the `elite` default metadata entry.
- Migration safety: if a cached profile/options/plan snapshot still contains `elite` (user updated the app before re-fetching), map it to `advanced` at the mapper level (`workout_mappers.dart`) for `level`, so the UI never shows an unknown level. Remove this fallback in a later release.
- Update the level-description helper `_getLevelDescription` so only the three levels are handled.

**Tests:** mapper converts `elite` → `advanced`; level selector renders exactly three tiles; no remaining `elite` references (`grep -rn elite lib test` shows only the mapper fallback).

**Checklist**
- [ ] UI filter and default catalog cleaned
- [ ] Mapper fallback + test
- [ ] Docs updated

**Commit message**
```
refactor(workout): drop the elite level from the app

The backend merged elite into advanced. Remove the hidden-level filter and
default metadata entry, and map any cached elite value to advanced so older
cached data never shows an unknown level.
```

---

## Phase FA6 — Tests, l10n, release notes

**Tasks**
- Run `flutter gen-l10n` and `dart run build_runner build --delete-conflicting-outputs`; commit generated files only if the repo tracks them.
- Run `flutter analyze` and `flutter test`; report failures honestly.
- Manual QA matrix (device or emulator):
  1. Bodybuilding + beginner → `full_body` → 2–4 chips; switch to `upper_lower` → value stays or syncs, never an unselected state.
  2. Bodybuilding + advanced → `bro_split` → chips 3–6 (after backend B12) with «پیشنهادی» on 5; with an old backend → single chip pre-selected.
  3. Switch level advanced → beginner with `bro_split` selected → style cleared with toast.
  4. Two disciplines → range 2–6.
  5. Small screen (320 px) and font scale 1.5.
  6. Edit an existing profile saved before the update.
- Update `WORKOUT_FEATURE.md` and `UI_REDESIGN_CHECKLIST.md` if they describe the days/levels behavior.
- Prepare store release notes (fa + en): "Training days per week are now more flexible for every program; improved workout plans."

**Commit message**
```
chore(workout): regenerate l10n and update docs for the days-per-week fix

Regenerate localization, update workout feature docs and add release notes
for the flexible days-per-week and level changes.
```

---

## Guardrails

- Never hard-code day ranges or levels in Flutter; always derive them from the options payload.
- Keep optional/new JSON fields nullable so the app works with both old and new backends.
- Do not change the profile request/response shape or the plan/session schema.
