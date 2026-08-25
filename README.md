# FitSho Mobile (فیت‌شو)

Flutter mobile client for **FitSho**, a Persian health, fitness & nutrition assistant. The app connects to the Node.js backend (`backend/what2eat-backend`) and lets users authenticate via mobile OTP, set dietary preferences, and get an AI-generated personalized weekly diet plan with meal logging, supplement tracking, and BMI/calorie dashboards.

**Platforms:** Android & iOS only — no web or desktop targets, and no responsive/tablet layout system is required.

**Reference project:** Architectural patterns are inspired by [Flutter-Notes](https://github.com/MohsenNiazmand/Flutter-Notes) (Clean Architecture, Riverpod, GoRouter, Dio, Retrofit). Responsive UI utilities from that project are **not** needed here.

---

## Table of Contents

- [Backend Integration](#backend-integration)
- [Architecture Overview](#architecture-overview)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Development Phases](#development-phases)
- [Development Progress](#development-progress)
- [Setup](#setup)
- [Code Generation](#code-generation)
- [Conventions](#conventions)
- [Agent Instructions](#agent-instructions)

---

## Backend Integration

The backend README lives at `backend/what2eat-backend/README.md`. Key facts the mobile app must respect:

| Area | Detail |
|------|--------|
| Base URL | `http://localhost:3000` (dev) — configurable per environment |
| Auth | OTP + JWT (access 15 min, refresh 7 days) |
| Device ID | Required on every auth call; must be persisted locally |
| Dev OTP | Fixed `123456` when `NODE_ENV !== 'production'` |
| Single session | New login invalidates previous sessions on the server |
| Content language | Recipe content is **Persian**; API field names and errors are **English** |
| Response envelope | Most endpoints: `{ "success": true, "data": ... }` |
| Auth endpoints | `otp/verify` and `refresh` return tokens at top level (no `success` wrapper) |

### API Endpoints Used by Mobile

| Method | Path | Feature |
|--------|------|---------|
| `POST` | `/api/auth/otp/request` | Request OTP |
| `POST` | `/api/auth/otp/verify` | Verify OTP, receive tokens |
| `POST` | `/api/auth/refresh` | Refresh access token |
| `POST` | `/api/auth/logout` | Invalidate session |
| `GET` | `/api/auth/me` | Current user profile |
| `PATCH` | `/api/auth/me` | Update display name |
| `GET` | `/api/preferences` | Get dietary preferences |
| `PUT` | `/api/preferences` | Create/update preferences |
| `DELETE` | `/api/preferences` | Delete preferences |
| `POST` | `/api/recipes/generate` | AI recipe generation |
| `GET` | `/api/recipes` | List/search recipes (paginated) |
| `GET` | `/api/recipes/:id` | Recipe detail |
| `GET` | `/api/favorites` | List favorites |
| `POST` | `/api/favorites` | Add favorite |
| `DELETE` | `/api/favorites/:recipeId` | Remove favorite |

---

## Architecture Overview

The app follows **Clean Architecture** with feature-based modules. Dependency direction:

```
Presentation  →  Domain  ←  Data
(UI, Providers)   (Entities,     (Repositories,
                   Use Cases,     API Services,
                   Repo IFaces)   Local Storage)
```

### State Management Flow

```
User Action → Riverpod Provider → Use Case → Repository → API / Secure Storage
     ↓
UI Update ← Provider State ← Either<Failure, Success> ← Response
```

### Key Patterns (from Flutter-Notes)

- **Repository pattern** — abstract data access behind domain interfaces
- **Use case pattern** — one class per business operation
- **Riverpod + hooks_riverpod** — reactive state with `@riverpod` code generation
- **GetIt** — service locator for non-widget dependencies (Dio, repositories)
- **Either / Failure** — typed error handling via `fpdart` or custom `Result` type
- **Retrofit + Dio** — type-safe HTTP clients with interceptors

---

## Tech Stack

| Category | Package |
|----------|---------|
| State management | `hooks_riverpod`, `riverpod_annotation`, `riverpod_generator`, `flutter_hooks` |
| Navigation | `go_router` |
| Networking | `dio`, `retrofit`, `retrofit_generator`, `curl_logger_dio_interceptor` |
| Serialization | `json_annotation`, `json_serializable`, `freezed` (optional) |
| Local storage | `flutter_secure_storage`, `shared_preferences` |
| DI | `get_it` |
| Utilities | `fpdart`, `logger`, `uuid` |
| UI feedback | `bot_toast` |
| Code quality | `very_good_analysis` or `flutter_lints` |
| Code generation | `build_runner` |

---

## Project Structure

Target layout (to be created incrementally across phases):

```
lib/
├── main.dart
├── core/
│   ├── constants/          # API URLs, storage keys, app constants
│   ├── error/              # Failures, exceptions, error mapper
│   ├── extensions/         # String, context, date extensions
│   ├── network/            # Dio client, interceptors, auth token manager
│   ├── utils/              # Device ID, validators (mobile format)
│   └── injection_container.dart
├── config/
│   ├── router/             # GoRouter routes, redirects, shell routes
│   └── theme/              # AppTheme, colors, typography (RTL-aware)
├── features/
│   ├── splash/
│   │   └── presentation/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── services/   # AuthApi (Retrofit)
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── profile/
│   ├── preferences/
│   ├── recipes/
│   │   ├── generate/       # AI generation flow
│   │   ├── list/           # Browse & search
│   │   └── detail/         # Single recipe view
│   ├── favorites/
│   └── main/               # Bottom navigation shell
└── shared/
    ├── data/
    │   └── models/         # ApiResponse wrapper, pagination model
    ├── domain/
    │   └── entities/       # Recipe, Ingredient (shared across features)
    └── presentation/
        └── widgets/        # Loading, empty state, error, buttons
```

---

## Development Phases

Development is **strictly phased**. Complete one phase, commit, update [Development Progress](#development-progress), then wait for explicit approval before starting the next phase.

---

### Phase 0 — Documentation & Development Plan

**Goal:** Establish the roadmap and agent handoff documentation.

**Deliverables:**
- [x] This README with full phase breakdown
- [x] Development Progress tracker section
- [x] Backend API mapping documented

**Status:** ✅ Complete

---

### Phase 1 — Project Scaffold & Core Infrastructure

**Goal:** Replace the default Flutter template with the architectural foundation.

**Tasks:**
- Add all dependencies to `pubspec.yaml`
- Create folder structure under `lib/`
- Set up `main.dart` with `ProviderScope`, `HookConsumerWidget` entry
- Implement `core/constants/` (API base URL, storage keys)
- Implement `core/error/` (`Failure`, `ServerFailure`, `NetworkFailure`, etc.)
- Implement `core/injection_container.dart` with GetIt
- Implement `config/theme/app_theme.dart` (Material 3, RTL support)
- Implement `config/router/app_router.dart` (skeleton routes, placeholder screens)
- Configure `analysis_options.yaml` (very_good_analysis)
- Add `.env` or flavor-based config for API base URL (dev/staging/prod)
- Remove default counter demo from `main.dart`

**Deliverables:**
- [x] Dependencies added to `pubspec.yaml`
- [x] Clean Architecture folder structure under `lib/`
- [x] Core constants, errors, GetIt injection container
- [x] Material 3 theme with RTL support
- [x] GoRouter with splash, login placeholder, and bottom-nav shell
- [x] `AppConfig` via `--dart-define=API_BASE_URL=...`
- [x] Counter demo removed; `flutter analyze` passes

**Status:** ✅ Complete

---

### Phase 2 — Networking Layer & Localization

**Goal:** Type-safe HTTP client wired to the What2Eat backend, plus l10n for all UI strings.

**Tasks:**
- Set up l10n (`l10n.yaml`, `app_en.arb`, `app_fa.arb`) and migrate all hardcoded UI strings
- Configure Dio with base URL, timeouts, logging interceptor
- Create envelope/pagination models matching backend response shape
- Define Retrofit services:
  - `AuthApi` — otp/request, otp/verify, refresh, logout, me (GET/PATCH)
  - `RecipeApi` — generate, list, getById
  - `PreferenceApi` — get, put, delete
  - `FavoriteApi` — list, add, remove
- Create JSON models for all request/response bodies (User, Recipe, Ingredient, Preference, Favorite)
- Register Dio and API services in GetIt
- Run `build_runner` and verify generated code compiles

**Deliverables:**
- [x] l10n setup with Persian (fa) and English (en) ARB files
- [x] All UI strings migrated to `AppLocalizations`
- [x] Dio client with dev logging interceptor
- [x] Retrofit APIs: Auth, Recipe, Preference, Favorite
- [x] JSON models with `json_serializable` code generation
- [x] GetIt registration for Dio and all API services
- [x] `flutter analyze` and `flutter test` pass

**Status:** ✅ Complete

---

### Phase 3 — Auth Interceptor & Secure Storage

**Goal:** Persistent authentication with automatic token refresh.

**Tasks:**
- Implement `TokenStorage` with `flutter_secure_storage` (accessToken, refreshToken)
- Implement `DeviceIdService` — generate UUID once, persist in secure storage
- Implement `AuthInterceptor` on Dio:
  - Attach `Authorization: Bearer` header on protected routes
  - On 401: attempt refresh via `/api/auth/refresh`, retry original request
  - On refresh failure: clear tokens, redirect to login
- Wire interceptor into Dio via GetIt

**Deliverables:**
- [x] `TokenStorage` interface + `SecureTokenStorage` implementation
- [x] `DeviceIdService` with UUID generation and persistence
- [x] `AuthInterceptor` (Bearer header, 401 refresh + retry, session expiry redirect)
- [x] Dedicated `_refreshDio` to avoid interceptor recursion
- [x] Wired into `createDio()` and GetIt

**Status:** ✅ Complete

---

### Phase 4 — Domain Layer (Auth & Shared Entities)

**Goal:** Business logic contracts independent of Flutter/UI.

**Tasks:**
- Domain entities: `User`, `Recipe`, `Ingredient`, `Preference`, `Favorite`
- Repository interfaces:
  - `AuthRepository`
  - `RecipeRepository`
  - `PreferenceRepository`
  - `FavoriteRepository`
- Use cases:
  - Auth: `RequestOtp`, `VerifyOtp`, `RefreshToken`, `Logout`, `GetCurrentUser`, `IsLoggedIn`
  - Profile: `UpdateProfile`
- Repository implementations in `data/` layer mapping models ↔ entities
- Register all in GetIt

**Deliverables:**
- [x] Domain entities in `shared/domain/entities/`
- [x] Model → entity mappers in `shared/data/mappers/entity_mappers.dart`
- [x] Repository interfaces + implementations for all 4 features
- [x] Auth use cases with `Either<Failure, T>` via fpdart
- [x] `UseCase` base + `guard()` helper for repository error mapping
- [x] All repositories and use cases registered in GetIt

**Status:** ✅ Complete

---

### Phase 5 — Authentication UI & Routing

**Goal:** Full OTP login flow with guarded navigation.

**Tasks:**
- Screens:
  - `SplashScreen` — check auth state, redirect
  - `LoginScreen` — mobile number input (validate `^09\d{9}$`)
  - `OtpVerificationScreen` — 6-digit OTP input
- Riverpod providers (`@riverpod`):
  - `authStateProvider` — logged in / logged out
  - `loginNotifier` — request OTP
  - `verifyOtpNotifier` — verify and store tokens
  - `logoutNotifier`
- GoRouter redirect logic:
  - Unauthenticated → `/login`
  - Authenticated → `/home`
- Persist user info after verify

**Deliverables:**
- [x] `LoginScreen` with mobile validation and OTP request
- [x] `OtpVerificationScreen` with Pinput (6-digit) and resend
- [x] Riverpod providers: auth state, current user, login, verify, logout
- [x] `goRouterProvider` with auth redirect guards
- [x] Splash wired to `checkSession()` + auto redirect
- [x] User persisted in `currentUserProvider` after verify

**Status:** ✅ Complete

---

### Phase 6 — Main Shell & Profile

**Goal:** App navigation shell and user profile management.

**Tasks:**
- `MainShell` with bottom navigation (e.g. Home, Generate, Favorites, Profile)
- Profile screen:
  - Display mobile number and name
  - Edit display name (`PATCH /api/auth/me`)
  - Logout button
- Profile Riverpod providers and use case wiring
- Placeholder screens for tabs not yet implemented

**Deliverables:**
- [x] `MainShellScreen` bottom navigation (from Phase 1, unchanged)
- [x] `ProfileScreen` — display mobile/name, edit name, logout with confirmation
- [x] `UpdateProfileNotifier` + `ProfileRefreshNotifier` providers
- [x] Logout wired via `LogoutNotifier` with redirect to login
- [x] Other tabs remain placeholders until Phases 8–10

**Status:** ✅ Complete

---

### Phase 7 — Preferences Feature

**Goal:** Dietary restrictions and cuisine preferences management.

**Tasks:**
- Domain: `Preference` entity, `GetPreferences`, `SavePreferences`, `DeletePreferences` use cases
- Preference repository implementation
- Preferences screen:
  - Multi-select or chip UI for dietary restrictions
  - Multi-select for preferred cuisines
  - Save (PUT) and delete actions
- Handle 404 on GET (no preferences yet) — show empty form
- Optional: prompt new users to set preferences after first login

**Deliverables:**
- [x] `GetPreferencesUseCase`, `SavePreferencesUseCase`, `DeletePreferencesUseCase`
- [x] 404 on GET mapped to empty form (no error shown)
- [x] `PreferencesScreen` with chip multi-select for dietary/cuisine options
- [x] Save (PUT upsert) and delete with confirmation dialog
- [x] Navigation from Profile via `/preferences` route
- [x] Localized option labels (fa/en); API values in English

**Status:** ✅ Complete

---

### Phase 8 — Recipe Generation (AI)

**Goal:** Core feature — generate a Persian recipe from ingredients.

**Tasks:**
- `GenerateRecipe` use case calling `POST /api/recipes/generate`
- Generate screen UI:
  - Dynamic ingredient input list (add/remove chips or text fields)
  - Optional: tools, calorie limit, servings
  - Submit button with loading state (AI calls can take several seconds)
- Recipe detail screen (shared with Phase 9):
  - Title, description, ingredients, instructions
  - Prep/cook time, servings, calories, category
- Error handling for 502 (AI provider failure)
- Navigate to detail on success

**Deliverables:**
- [x] `GenerateRecipeUseCase` and `GetRecipeByIdUseCase`
- [x] `GenerateRecipeScreen` with dynamic ingredient/tool inputs and optional fields
- [x] `RecipeDetailScreen` + `RecipeDetailContent` (shared with Phase 9)
- [x] `AiProviderFailure` for 502 responses
- [x] Navigate to `/recipes/:id` on successful generation

**Status:** ✅ Complete

---

### Phase 9 — Recipe Browse & Search

**Goal:** Paginated recipe list with search and category filter.

**Tasks:**
- `ListRecipes`, `GetRecipeById` use cases
- Recipe list screen (Home tab):
  - Paginated list with infinite scroll or load-more
  - Search bar (`q` parameter)
  - Category filter (optional dropdown)
  - Pull-to-refresh
- Recipe detail screen integration (from favorites/list/generate)
- Empty and loading states

**Deliverables:**
- [x] `ListRecipesUseCase` (GetRecipeById from Phase 8)
- [x] `RecipeListScreen` on Home tab with search, category filter, pagination
- [x] Infinite scroll load-more and pull-to-refresh
- [x] Tap recipe → `RecipeDetailScreen` with recipe extra
- [x] Empty, loading, and error states

**Status:** ✅ Complete

---

### Phase 10 — Favorites Feature

**Goal:** Save and manage favorite recipes.

**Tasks:**
- Domain: `AddFavorite`, `RemoveFavorite`, `ListFavorites`, `IsFavorite` use cases
- Favorite toggle on recipe detail screen (heart icon)
- Favorites tab screen — list with recipe title, category, tap → detail
- Handle 409 conflict (already favorited) gracefully
- Optimistic UI update optional (rollback on failure)

**Deliverables:**
- [x] Favorites use cases with 409 → success in `AddFavoriteUseCase`
- [x] `ConflictFailure` for 409 responses
- [x] `FavoritesScreen` on Favorites tab with pull-to-refresh
- [x] `FavoriteButton` heart toggle on `RecipeDetailScreen`
- [x] `favoriteRecipeIdsProvider` for synced favorite state

**Status:** ✅ Complete

---

### Phase 11 — Polish & UX Finalization

**Goal:** Production-quality mobile UX for Android and iOS.

**Tasks:**
- Shared widgets: loading shimmer/spinner, empty states, error retry widgets
- Toast notifications via `bot_toast` (success, error messages)
- Persian/RTL layout verification on all screens
- Input validation messages (mobile format, required ingredients)
- App icon and splash screen (optional)
- Handle edge cases:
  - No network connectivity message
  - Session expired → redirect to login
  - Empty favorites / empty recipe list states
- Final `flutter analyze` cleanup

**Deliverables:**
- [x] Shared widgets: `AppLoadingIndicator`, `EmptyStateView`, `ErrorRetryView`
- [x] Localized failure messages via `failureMessage()` and updated toasts
- [x] Session expiry clears auth state, shows toast, redirects to login
- [x] Screens refactored to use shared loading/empty/error widgets
- [x] Removed unused placeholder tab code

**Status:** ✅ Complete

---

### Phase 12 — Testing (Optional / If Requested)

**Goal:** Automated test coverage for critical paths.

**Tasks:**
- Unit tests for use cases (mock repositories)
- Unit tests for repository implementations (mock Dio)
- Widget tests for auth screens and recipe detail
- Integration test for OTP login flow (optional, requires running backend)

**Acceptance criteria:**
- `flutter test` passes
- Core business logic covered

---

## Development Progress

> **Important for agents:** Update this section at the end of every completed phase before committing. A new agent should read this first to know exactly where development stopped and what to do next.

| Field | Value |
|-------|-------|
| **Last Completed Phase** | Phase 11 — Polish & UX Finalization |
| **Completed At** | 2026-07-15 |
| **Next Phase** | Phase 12 — Testing (Optional) |
| **Commit Scope** | `mobile/what_2_eat/` |

### What Has Been Done

- Phase 0–5: Full foundation through OTP authentication
- Phase 6: Profile feature (display/edit name, logout)
- Phase 7: Preferences feature (dietary/cuisine chips, CRUD)
- Phase 8: Recipe generation (Generate tab, detail screen, 502 handling)
- Phase 9: Recipe browse & search (Home tab, pagination, filters)
- Phase 10: Favorites feature (tab, heart toggle, 409 handling)
- Phase 11: Polish & UX
  - Shared loading, empty, and error-retry widgets
  - Localized network/session error toasts
  - Session expiry syncs auth state + redirect
  - `flutter analyze` and `flutter test` pass

### What To Do Next (Phase 12 — Optional)

1. Add unit tests for use cases (mock repositories)
2. Add widget tests for auth and recipe detail screens
3. Update **Development Progress** if tests are requested
4. Provide English commit message to the user (do not run git commands)

### Phase Completion Checklist

When finishing any phase, the agent must:

1. Mark phase deliverables as done in this README (if applicable)
2. Update the **Development Progress** table (Last Completed Phase, Completed At, Next Phase, Commit Scope)
3. Update **What Has Been Done** and **What To Do Next** sections
4. Run `flutter analyze` (and `flutter test` if tests exist)
5. Give the user an English commit message — **never run git commands automatically**

---

## Setup

### Prerequisites

- Flutter 3.4+ / Dart 3.0+
- Android Studio or Xcode for device emulators
- What2Eat backend running locally (see `backend/what2eat-backend/README.md`)

### Installation

```bash
cd mobile/what_2_eat
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter run -d android   # or -d ios
```

### Backend (Local Dev)

```bash
cd backend/what2eat-backend
docker-compose up -d
npm install
cp .env.example .env
npx prisma migrate dev
npm run dev
```

Use OTP `123456` in development mode.

### Android Emulator Networking

To reach `localhost:3000` from an Android emulator, use `http://10.0.2.2:3000` as the API base URL.

---

## Code Generation

After modifying Retrofit services, Riverpod providers, or JSON models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Conventions

1. **Clean Architecture** — no API calls from widgets; always go through providers → use cases → repositories
2. **Feature-first folders** — each feature owns its data/domain/presentation layers
3. **Persian UI, English code** — user-facing strings via l10n ARB files (`lib/l10n/`); code identifiers and comments in English
4. **No hardcoded UI strings** — always use `context.tr` via `AppLocalizationHelper`
5. **No Persian comments in code**
5. **Mobile only** — no responsive breakpoints, no web/desktop targets
6. **RTL** — enable RTL support in MaterialApp; test layouts with Persian text
7. **Phased commits** — one phase per commit unless the user requests otherwise
8. **Backend field names** — use `mobileNumber` (not `mobile`) to match API JSON

---

## Agent Instructions

When assigned to continue this project:

1. Read this README fully, especially [Development Progress](#development-progress)
2. Read `backend/what2eat-backend/README.md` for API contracts
3. Use [Flutter-Notes](https://github.com/MohsenNiazmand/Flutter-Notes) as an architectural reference (not responsive UI patterns)
4. Implement **only the next phase** listed in Development Progress
5. Do **not** start the following phase until the user explicitly approves
6. At phase completion: update Development Progress, run analyzer, provide English commit message
7. Never execute git commands — the user commits manually

---

## License

Private project. All rights reserved.
