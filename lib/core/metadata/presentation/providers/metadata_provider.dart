import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../default_catalog.dart';
import '../../domain/entities/metadata_catalog.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/repositories/metadata_repository.dart';
import '../../../injection_container.dart';

final metadataRepositoryProvider = Provider<MetadataRepository>((ref) {
  return getIt<MetadataRepository>();
});

class MetadataNotifier extends StateNotifier<MetadataCatalog> {
  MetadataNotifier(this._repository) : super(DefaultCatalog.asCatalog()) {
    _init();
  }

  final MetadataRepository _repository;

  Future<void> _init() async {
    final initial = await _repository.getInitialCatalog();
    state = initial;

    await syncWithRemote();
  }

  Future<void> syncWithRemote() async {
    try {
      final res = await _repository.syncCatalogIfNeeded(state.version);
      res.fold(
        (failure) {},
        (newCatalog) {
          if (newCatalog != null) {
            state = newCatalog;
          }
        },
      );
    } catch (_) {
      // Ignore background sync errors
    }
  }

  Future<void> refresh() async {
    final res = await _repository.fetchFreshCatalog();
    res.fold(
      (failure) {},
      (newCatalog) {
        state = newCatalog;
      },
    );
  }
}

final metadataCatalogProvider =
    StateNotifierProvider<MetadataNotifier, MetadataCatalog>((ref) {
  final repository = ref.watch(metadataRepositoryProvider);
  return MetadataNotifier(repository);
});

final muscleGroupsProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('muscle_group');
});

final exerciseCategoriesProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('exercise_category');
});

final movementPatternsProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('movement_pattern');
});

final equipmentProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('equipment');
});

final workoutTypesProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('workout_type');
});

final injuryTypesProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('injury_type');
});

final goalsProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('goal');
});

final difficultyLevelsProvider = Provider<List<MetadataItem>>((ref) {
  return ref.watch(metadataCatalogProvider).getByType('difficulty_level');
});
