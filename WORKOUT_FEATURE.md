# Workout Plan Feature — Flutter Development Guide

> **For AI agents:** Read this whole file and `../FitSho-backend/WORKOUT_FEATURE.md` (API contract, domain rules) before coding. Implement **only the next phase** marked ⬜ below. When a phase is done: tick its deliverables, update the Progress table, run `flutter analyze` and `flutter test`, give the user an **English commit message**, then **stop and wait** for approval. Never run git commands. A Flutter phase may only start after the backend phase(s) it depends on are done.

## Progress

| Phase | Title | Depends on backend | Status |
|-------|-------|--------------------|--------|
| F1 | Data layer (models, API, repository, cache, DI) | B1–B5 contract | ☑ |
| F2 | Workout profile wizard | B1, B2 | ☑ |
| F3 | Workout tab + plan screen + generation | B3, B4 | ☑ |
| F4 | Exercise swap | B5 | ⬜ |
| F5 | Workout history | B4 | ⬜ |
| F6 | Profile edit, regenerate prompt, polish, tests | all | ⬜ |

Last completed phase: **F3** · Next phase: **F4**

---

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

## Phase F4 — Swap ⬜
- `WorkoutPlanNotifier.swapExercise({planId, day, itemId})` → replace the item in state and in cache, update `remainingExerciseSwaps`.
- Card shows spinner while swapping (one at a time, like `DietPlanSection.swappingKey`); swap icon hidden when remaining == 0 or plan is read-only.
Deliverables: [ ] notifier method [ ] UI [ ] test for in-place replacement.

---

## Phase F5 — History ⬜
- `WorkoutHistoryNotifier` (page 1, limit 20, load-more on scroll).
- `WorkoutHistoryScreen` (route `/workout/history`, pushed from plan screen app bar) and read-only `WorkoutPlanDetailScreen` reusing `WorkoutDaySection` with `readOnly: true`.
- Delete with confirm dialog; deleting the active plan invalidates `WorkoutPlanNotifier`.
Deliverables: [ ] notifier [ ] screens [ ] delete flow.

---

## Phase F6 — Polish ⬜
- Edit profile entry point + `shouldRegeneratePlan` bottom sheet → generate.
- Empty/loading/error states on every screen; pull-to-refresh.
- Reset workout providers on logout/delete account.
- Tests: mappers, notifier swap logic, wizard validation.
- Update README «Development Progress» section with the workout feature.
