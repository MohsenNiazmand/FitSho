# Dynamic Exercises Feature (Flutter)

This document outlines the frontend development phases to support media-rich (GIFs/Videos) exercises returned from the backend.

## Phase F1: Update Exercise Models (✅ Done)
**Goal:** Parse the new `gifUrl` and `videoUrl` fields from the backend JSON response.
- **Tasks:**
  - Add `final String? gifUrl;` and `final String? videoUrl;` to the `WorkoutExerciseItem` entity.
  - Update `WorkoutExerciseItemModel.fromJson` and `toJson` to map these keys.
  - Update unit tests in `workout_models_test.dart` to assert correct parsing of media URLs.
- **Commit Message:** `feat(workout): add media urls to exercise item models`

## Phase F2: Update Workout UI Components (✅ Done)
**Goal:** Display the exercise media gracefully in the workout flow.
- **Tasks:**
  - Update `WorkoutExerciseCard` (`lib/features/workout/presentation/widgets/workout_exercise_card.dart`) to show a thumbnail or placeholder if a `gifUrl` is present.
  - Create or update the Exercise Details modal/screen to autoplay the `gifUrl` (using a network image caching library like `cached_network_image`).
  - Ensure the UI handles missing media (null `gifUrl`) elegantly with fallback icons.
- **Commit Message:** `feat(workout): display exercise media in workout UI`
