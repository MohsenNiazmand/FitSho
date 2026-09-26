# Workout Plan Feature — Flutter Development Guide

> **For AI agents:** Read this whole file and `../FitSho-backend/WORKOUT_FEATURE.md` before coding. The original F1–F6 implementation is complete; the pending revision phases below supersede conflicting requirements in the original scenario/model sections. Implement **all pending F7–F11 phases in ascending order in one task**, testing each phase before moving to the next and ticking its deliverables. Start only after backend B7–B11 are complete; the backend document is the source of truth for API/validation. At completion run `flutter analyze` and `flutter test`, report results and an **English commit message**, then stop for review. Never run git commands.

## Progress

| Phase | Title | Depends on backend | Status |
|-------|-------|--------------------|--------|
| F1 | Data layer (models, API, repository, cache, DI) | B1–B5 contract | ☑ |
| F2 | Workout profile wizard | B1, B2 | ☑ |
| F3 | Workout tab + plan screen + generation | B3, B4 | ☑ |
| F4 | Exercise swap | B5 | ☑ |
| F5 | Workout history | B4 | ☑ |
| F6 | Profile edit, regenerate prompt, polish, tests | all | ☑ |

Original implementation baseline complete: **F1–F6** · Next revision phase: **F7**.

## Revision 2 — Flexible workout plan (authoritative next work)

The feature has not been released. These requirements intentionally replace the original calendar-week plan shape, single-goal profile, combined injury list, level labels and fixed-only session-duration rules below. Do not preserve obsolete behavior merely for backward compatibility. Coordinate against `../FitSho-backend/WORKOUT_FEATURE.md` Revision 2; both projects must implement the same wire contract.

### Shared contract (must match backend exactly)

- A plan contains `sessions`, not weekday entries. It contains exactly `daysPerWeek` training sessions and no generated rest-day entries. Each session has a stable `sessionId` (`session_1` … `session_N`), one-based `sessionNumber`, `title`, `focus`, `durationMin`, and `warmup`, `main`, `cooldown` exercise lists. Never derive or display a weekday or a required calendar schedule. The user decides which weekdays to train.
- Swap request body is `{ "sessionId": "session_1", "itemId": "..." }`; the route remains `POST /workout-plans/:id/swap-exercise`. Replace the item inside the matching session in state and cache.
- Workout profile uses `primaryGoal` (required) and `secondaryGoal` (nullable, at most one). The secondary goal is lower priority. Both must be compatible with at least one selected discipline. The server response and plan `profileSnapshot` use these exact keys.
- Profile uses `injuryAreas` (0–2 body-region ids) and `medicalConditions` (zero or more ids) separately. `painLevel` remains one overall 0–10 rating for the selected affected areas; high pain and referral-required medical conditions still block generation server-side. `injuryNotes` remains optional Persian text.
- Options levels have `{ id, label, description, isAvailable }`; `label` is only the short level name. Options also provide `minSessionMinutes: 10` and `maxSessionMinutes: 180`. `sessionMinutes` remains the suggested chip list; any integer in the inclusive min/max range is valid.
- `bodybuilding` and `fitness` are allowed together. They represent complementary modalities; when both are selected, the profile contains one style for each and the generated plan must visibly cover both styles. Do not add a mutual-exclusion rule.

### Revision phases

| Phase | Title | Depends on backend | Status |
|---|---|---|---|
| F7 | Session-based models, plan UI, history and swap | B7 | ☑ |
| F8 | New-plan choice dialog and edit handoff | B7 | ☑ |
| F9 | Primary/secondary goals and discipline pairing | B8 | ☑ |
| F10 | Injury areas/medical conditions and style clearing | B9 | ☑ |
| F11 | Level descriptions, custom duration and final validation | B10 | ☑ |

## Revision phase F7 — Session-based plans ☑

**Depends on backend B7.** Replace the client plan contract end-to-end; do not add a presentation-only label over weekday-bound data.

**Files/surfaces**
- `lib/features/workout/data/models/workout_models.dart` and `.g.dart`: model `sessions`, `sessionId`, `sessionNumber`; preserve existing exercise and quota fields. Update history envelope parsing and JSON/cache round-trip tests.
- `domain/entities/workout_entities.dart`, `data/mappers/workout_mappers.dart`, `data/services/workout_api.dart` and generated `.g.dart`, `data/repositories/workout_repository_impl.dart`, `presentation/providers/workout_providers.dart`.
- Rename or refactor `WorkoutDaySection` to a session section; update `WorkoutPlanScreen`, `WorkoutPlanDetailScreen`, history navigation, and all affected widget tests.

**Behavior**
- Show exactly N horizontally scrollable tabs labeled with localized `Session 1` … `Session N` (`جلسه ۱` … `جلسه N`) for N sessions. No Saturday-first ordering, today highlighting, rest-day chip, weekday localization, or inferred training schedule.
- Each selected session retains title, focus, duration and the existing warm-up/main/cool-down sections. A read-only history plan uses the same session UI.
- Swap submits `sessionId`, replaces the matching exercise in the selected session, updates the active plan and SharedPreferences cache, and never changes another session. Preserve existing confirmation, loading, quota and no-alternative error UX.
- History displays profile snapshot disciplines, `daysPerWeek` and active/archived status. Use option labels when cached/fetched options exist; fall back to ids without failing offline.
- Do not create rest sessions to pad the list. `WorkoutPlan.days` is replaced by `WorkoutPlan.sessions` in Dart models/entities and all callers.

**Acceptance/tests**
- Model tests parse and serialize session plans and history `profileSnapshot`; malformed/missing optional snapshot still does not crash.
- Notifier/repository test swaps an item in one session in-place and verifies the `sessionId` request and cache update.
- Widget tests for N=2, N=3 and N=6 show exactly N `Session N` tabs, no weekday/rest labels, plus read-only history behavior.
- Run `dart run build_runner build --delete-conflicting-outputs` for the touched generated serializers/API only, `flutter test test/features/workout`, then `flutter analyze` and `flutter test`.

## Revision phase F8 — New plan choice ☑

**Depends on backend B7; implement after F7.** In `WorkoutPlanScreen` and the plan header, intercept the new-plan button while an active plan exists and show a localized dialog/bottom sheet with exactly two actions:

1. **Use current details and create a new plan**: close the dialog and use the existing generation/loading/error flow; do not open the profile wizard or mutate the profile.
2. **Edit workout details**: open the existing prefilled workout profile wizard. If the user cancels, do not generate. If they save, continue to generation once using the just-saved profile; do not show a second `shouldRegeneratePlan` prompt because the user already chose to edit for this new plan.

When there is no active plan (first generation), keep the direct generate action; there is no previous-plan choice to make. Preserve quota-disabled behavior, medical referral dialog, 429 toast, 502 retry and mounted-context checks. Keep the app-bar edit-profile flow separate: ordinary profile edits may continue to use the existing `shouldRegeneratePlan` prompt.

**Acceptance/tests:** widget tests cover both actions, canceling edit, saving then exactly one generation, first-generation direct flow, and exhausted quota. Dialog strings and semantics must be localized in both ARB files.

## Revision phase F9 — Disciplines and prioritized goals ☑

**Depends on backend B8; implement after F8.**
- Keep the disciplines step and max two disciplines. Specifically allow bodybuilding + fitness together; display API-provided descriptions that explain resistance/bodybuilding focus versus broad conditioning/fitness. Do not imply they are mutually exclusive.
- Keep a distinct goal step because discipline describes training modality while goal describes desired outcome. Change it from single selection to at most two selected goals: one required primary and one optional secondary. UI must visibly label which is primary; selecting a second does not silently make priority ambiguous. Permit changing primary among selected goals. Both choices must be compatible with at least one selected discipline. No more than two.
- Replace profile entity/model/request fields `goal` with `primaryGoal` and nullable `secondaryGoal` as defined in the shared contract. Update profile prefill/save, cache, mappers, regenerate-change detection and strings. When only one goal is chosen, secondary is null.
- Add tests for compatible/incompatible combinations, selecting/removing a secondary goal, changing primary, profile edit prefill, request JSON and `shouldRegeneratePlan` result.

## Revision phase F10 — Injury data and clearable styles ☑

**Depends on backend B9; implement after F9.**
- Model and submit `injuryAreas` separately from `medicalConditions`. The injury step offers at most two selected body areas; selecting a third shows a localized message and does not change selection. Referral-required and other medical conditions use a separate multi-select with no two-area cap.
- Keep the no-injury control coherent: enabling it clears injury areas, medical conditions, pain and notes; selecting an area/condition turns it off. Pain-level warnings use selected areas; medical referral warnings use option metadata. Server remains authoritative for generation refusal.
- In the style radio group, tapping the currently selected style clears it. An unselected style remains required per selected discipline; validation prevents leaving the style step/saving until a valid style is selected. Removing a discipline also removes its style selection.
- Update profile/options models, form validation, save payload, edit prefill and tests for max-two areas, unlimited medical conditions, clearing behavior, referral-warning display and style deselection/reselection.

## Revision phase F11 — Level descriptions and custom duration ☑

**Depends on backend B10; implement after F10.**
- Replace the current one-line level choices with accessible, equal-width selectable tiles: short title on line one (`مبتدی`, `متوسط`, `پیشرفته`) and API-provided description on line two (e.g. `کمتر از ۶ ماه سابقه`). The backend `label` must not contain the explanation; use `description`. Support wrapping/RTL on narrow devices without clipping.
- Keep the API-provided suggested session-minute chips and add a custom integer-minutes input. Choosing a chip updates the same value; typing a valid custom value clears chip selection. Use numeric keyboard/input formatting for Persian and Latin digits, show localized validation for non-integer/out-of-range input, and preserve custom values when editing a profile.
- Add `minSessionMinutes`/`maxSessionMinutes` to the options model and enforce them client-side; do not hardcode separate client bounds. Keep submit payload as integer `sessionMinutes`.
- Tests cover localized level title/description, both digit sets, range edges 10 and 180, out-of-range/empty/decimal input, chip/custom transitions, edit prefill and API JSON.

### Required Flutter completion checks

- Update the route and navigation only if the existing flow requires it; do not change unrelated navigation.
- Update the old F1–F6 implementation notes below only where they conflict; this revision is the controlling contract.
- Tests must not depend on live backend/network. Add focused tests for each phase and run all Flutter tests before declaring the revision complete.
- Before implementation, confirm the matching backend phase and endpoint field names in `../FitSho-backend/WORKOUT_FEATURE.md`. If they disagree, stop and resolve the documents rather than inventing a client-only contract.

---

> **Historical baseline only:** The original F1–F6 requirements below describe the already implemented version. If any weekday, rest-day, one-goal, combined-injury, level-label or fixed-duration requirement conflicts with Revision 2 above, follow Revision 2. Do not restart or re-implement F1–F6.

## 1. Scenario (user view)

1. A new bottom-nav tab **«تمرین»** is added (between «برنامه غذایی» and «مکمل‌ها»).
2. Opening it:
   - No DietProfile → message + button to diet onboarding (reuse existing `dietOnboarding` route).
   - No WorkoutProfile (GET 404) → show the **workout wizard**.
   - Profile but no active plan → empty state + «ساخت برنامه تمرینی» button.
   - Active plan → plan screen.
3. **Wizard (5 steps, PageView, like `DietOnboardingForm`)**
   1. Disciplines: selectable cards (label + description), **max 2**; selecting a 3rd shows a toast.
   2. Level + style: level selector at the top (beginner/intermediate/advanced); below it, for each chosen discipline one radio group of its styles (label + description), showing only styles whose `levels` contain the selected level.
   3. Goal: only goals whose `compatibleDisciplines` intersect the chosen disciplines.
   4. Conditions: daysPerWeek (2–6 selector, limited to the chosen style's `minDays..maxDays` when one discipline), sessionMinutes chips, location (gym/home), equipment multi-select chips (hidden when gym).
   5. Injuries: «آسیب‌دیدگی ندارم» switch; otherwise multi-select injuries, pain slider 0–10, optional notes (`createPersianTextFormatter`). If painLevel ≥ 7 or a `requiresReferral` injury is selected, show an inline warning that a plan cannot be generated until a doctor/physiotherapist is consulted (still allow saving).
   Save → `PUT /workout-profile` → go to plan screen; if no active plan, offer to generate.
4. **Generate**: `AiLoadingDialog` (reuse, workout texts) → `POST /workout-plans/generate`.
   - 422 `MEDICAL_REFERRAL_REQUIRED` → dedicated dialog with the server message.
   - 429 → toast with server message; 502 → `aiProviderFailure` with retry.
5. **Plan screen**: day chips (Saturday-first, today highlighted, rest days styled differently) → selected day shows title, focus muscles, duration, then three sections: گرم کردن / تمرین اصلی / سرد کردن. Each exercise card: name, `sets × reps` or duration, rest, RPE, notes, swap icon. Header: plan summary, remaining generations/swaps, «برنامه جدید» button (disabled at 0), expandable «نکات پیشرفت» and «نکات ایمنی».
6. **Swap**: tap swap → confirm → `POST /workout-plans/:id/swap-exercise` → replace the card in place; toast with remaining swaps. 422 `NO_ALTERNATIVE_EXERCISE` → toast.
7. **History**: list of plans (date, disciplines, days/week, status badge active/archived) → tap opens read-only plan view (no swap/generate); delete with confirmation.
8. **Edit profile**: from the plan screen app bar → same wizard prefilled; when response has `shouldRegeneratePlan: true` show the regenerate bottom sheet (same UX as diet).

Out of scope: done-logging, reminders/notifications, images/videos, paid tiers.

## 2. Conventions (must follow)
Same as the rest of the app (README.md): feature-first Clean Architecture under `lib/features/workout/{data,domain,presentation}`, Riverpod `@riverpod` notifiers, GetIt, Retrofit + json_serializable (run `dart run build_runner build --delete-conflicting-outputs`, commit only regenerated files that belong to the change), `Either<Failure, T>` via `guard`, all strings in `app_fa.arb` / `app_en.arb` (`context.tr`), Persian digits via `PersianDigits`, RTL, shared widgets (`AppPrimaryButton`, `EmptyStateView`, `ErrorRetryView`, `Gap`, toasts). Option labels/descriptions come from the API — **do not hardcode them**.

---

## Phase F1 — Data layer ⬜

**Files**
```
lib/features/workout/
  data/models/workout_models.dart        # + .g.dart
  data/services/workout_api.dart         # Retrofit
  data/mappers/workout_mappers.dart
  data/datasources/workout_local_data_source.dart
  data/repositories/workout_repository_impl.dart
  domain/entities/workout_entities.dart
  domain/repositories/workout_repository.dart
```
**Retrofit endpoints** (base URL already `/api/v1/`):
`GET workout-profile/options`, `GET workout-profile`, `PUT workout-profile`, `POST workout-plans/generate`, `GET workout-plans`, `GET workout-plans/history` (`@Query('page')`, `@Query('limit')`), `DELETE workout-plans/{id}`, `POST workout-plans/{id}/swap-exercise`.

**Models / entities**
- `WorkoutOptions`: disciplines, styles (with `disciplineId`, `minDays`, `maxDays`, `levels`), goals (with `compatibleDisciplines`), levels, sessionMinutes (List<int>), locations, equipment, injuries (with `requiresReferral`), maxDisciplines, min/maxDaysPerWeek. Generic option item `{id, label, description?, isAvailable}`.
- `WorkoutProfile`: disciplines, styles (`Map<String,String>`), goal, level, daysPerWeek, sessionMinutes, location, equipment, injuries, injuryNotes, painLevel, shouldRegeneratePlan.
- `WorkoutPlan`: id, status, summary, notes (progression, safety list), days (List<WorkoutDay>), createdAt, profileSnapshot, remainingFullGenerations, remainingExerciseSwaps (json keys `remaining_full_generations`, `remaining_exercise_swaps`).
- `WorkoutDay`: day, isRest, title, focus, durationMin, warmup/main/cooldown (List<WorkoutExerciseItem>).
- `WorkoutExerciseItem`: itemId, exerciseId, name, sets, reps (String?), durationSec (int?), restSec, rpe (num?), notes.
- History envelope: `data: { items, pagination }` — parse `items` (do NOT repeat the old diet-history bug).
- Swap response: `{ item, remaining_exercise_swaps }`.
- Number parsing must tolerate strings (like `DietMealModel.fromJson`).

**Cache**: store options, profile and active plan as JSON strings in SharedPreferences (no new Hive adapters needed); stale-while-revalidate like `DietRepositoryImpl` (return cache on `NetworkFailure`). Clear it in `logout`/`deleteAccount` flows (`LogoutNotifier`, `DeleteAccountNotifier`).

**Errors**: add to `failures.dart` `MedicalReferralFailure` and map in `ExceptionMapper` when response `code == 'MEDICAL_REFERRAL_REQUIRED'` (check `code` before status mapping); `NO_ALTERNATIVE_EXERCISE` → `ValidationFailure(message)`. Update `failureMessage()` switch.

**DI**: register `WorkoutApi`, `WorkoutLocalDataSource`, `WorkoutRepository` in `injection_container.dart`.

Deliverables: [ ] models+codegen [ ] API [ ] repository + cache [ ] failures mapping [ ] DI [ ] unit tests for JSON parsing (history items, swap response, string numbers).

---

## Phase F2 — Wizard ☑

Deliverables: [x] providers [x] form + 2 screens [x] routes [x] l10n fa/en [x] widget test for max-2 disciplines rule.

---

## Phase F3 — Tab + plan screen + generate ☑

- Add `StatefulShellBranch` for `AppRoutes.workoutPlan = '/workout/plan'` in `go_router_provider.dart` at index 2; **shift supplements/profile indexes** and update `MainShellScreen` (`goBranch(2)` for supplements in navigation handling must become 3).
- `WorkoutPlanNotifier`: build (cache → revalidate), `generate()`, `refreshPlan()`, `delete(id)`, later `swap()`.
- Screens/widgets: `WorkoutPlanScreen`, `WorkoutDaySection` (day chips + sections), `WorkoutExerciseCard`, `WorkoutRestDayView`, `WorkoutPlanHeader` (limits + generate button + notes), `MedicalReferralDialog`.
- State routing inside the tab as described in Scenario §2.
Deliverables: [x] branch + nav [x] notifier [x] screen & widgets [x] generate flow with all error cases [x] l10n.

---

## Phase F4 — Swap ☑
- `WorkoutPlanNotifier.swapExercise({planId, day, itemId})` → replace the item in state and in cache, update `remainingExerciseSwaps`.
- Card shows spinner while swapping (one at a time, like `DietPlanSection.swappingKey`); swap icon hidden when remaining == 0 or plan is read-only.
Deliverables: [x] notifier method [x] UI [x] test for in-place replacement.

---

## Phase F5 — History ☑
- `WorkoutHistoryNotifier` (page 1, limit 20, load-more on scroll).
- `WorkoutHistoryScreen` (route `/workout/history`, pushed from plan screen app bar) and read-only `WorkoutPlanDetailScreen` reusing `WorkoutDaySection` with `readOnly: true`.
- Delete with confirm dialog; deleting the active plan invalidates `WorkoutPlanNotifier`.
Deliverables: [x] notifier [x] screens [x] delete flow.

---

## Phase F6 — Polish ☑
- Edit profile entry point + `shouldRegeneratePlan` bottom sheet → generate.
- Empty/loading/error states on every screen; pull-to-refresh.
- Reset workout providers on logout/delete account.
- Tests: mappers, notifier swap logic, wizard validation.
- Update README «Development Progress» section with the workout feature.
Deliverables: [x] edit profile + regenerate prompt [x] empty/loading/error states & refresh [x] auth cache reset [x] unit tests [x] docs.
