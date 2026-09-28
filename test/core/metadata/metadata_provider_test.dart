import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/metadata/default_catalog.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_catalog.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_item.dart';
import 'package:fitsho/core/metadata/domain/repositories/metadata_repository.dart';
import 'package:fitsho/core/metadata/presentation/providers/metadata_provider.dart';

class MockMetadataRepository implements MetadataRepository {
  MetadataCatalog initialCatalog = DefaultCatalog.asCatalog();
  MetadataCatalog? updatedCatalog;
  bool shouldFailSync = false;
  int syncCallCount = 0;

  @override
  Future<MetadataCatalog> getInitialCatalog() async => initialCatalog;

  @override
  Future<Either<Failure, int>> checkVersion() async {
    return right(updatedCatalog?.version ?? initialCatalog.version);
  }

  @override
  Future<Either<Failure, MetadataCatalog?>> syncCatalogIfNeeded(int currentVersion) async {
    syncCallCount++;
    if (shouldFailSync) {
      return left(const ServerFailure('Network error'));
    }
    if (updatedCatalog != null && updatedCatalog!.version > currentVersion) {
      return right(updatedCatalog);
    }
    return right(null);
  }

  @override
  Future<Either<Failure, MetadataCatalog>> fetchFreshCatalog() async {
    if (shouldFailSync) {
      return left(const ServerFailure('Network error'));
    }
    return right(updatedCatalog ?? initialCatalog);
  }
}

void main() {
  late MockMetadataRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockMetadataRepository();
    container = ProviderContainer(
      overrides: [
        metadataRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('loads initial fallback/cached catalog synchronously/on start', () async {
    final catalog = container.read(metadataCatalogProvider);
    expect(catalog.version, equals(DefaultCatalog.defaultVersion));
    expect(catalog.getByType('muscle_group'), isNotEmpty);
  });

  test('sub-providers filter items correctly by category', () async {
    final muscles = container.read(muscleGroupsProvider);
    expect(muscles, isNotEmpty);
    expect(muscles.any((m) => m.key == 'chest'), isTrue);

    final equipment = container.read(equipmentProvider);
    expect(equipment, isNotEmpty);
    expect(equipment.any((e) => e.key == 'dumbbell'), isTrue);

    final categories = container.read(exerciseCategoriesProvider);
    expect(categories, isNotEmpty);
    expect(categories.any((c) => c.key == 'strength'), isTrue);

    final patterns = container.read(movementPatternsProvider);
    expect(patterns, isNotEmpty);
    expect(patterns.any((p) => p.key == 'push'), isTrue);
  });

  test('updates state when background sync returns a newer version', () async {
    final newCatalog = MetadataCatalog(
      version: 5,
      updatedAt: DateTime(2026, 2, 1),
      catalog: {
        'muscle_group': [
          const MetadataItem(key: 'traps', labelFa: 'کول', labelEn: 'Traps'),
        ],
      },
    );

    mockRepo.updatedCatalog = newCatalog;

    final notifier = container.read(metadataCatalogProvider.notifier);
    await notifier.syncWithRemote();

    final state = container.read(metadataCatalogProvider);
    expect(state.version, equals(5));
    expect(state.getByType('muscle_group').length, equals(1));
    expect(state.getByType('muscle_group').first.key, equals('traps'));
  });

  test('silently keeps previous state on network error during sync', () async {
    mockRepo.shouldFailSync = true;
    final notifier = container.read(metadataCatalogProvider.notifier);
    await notifier.syncWithRemote();

    final state = container.read(metadataCatalogProvider);
    expect(state.version, equals(DefaultCatalog.defaultVersion));
    expect(state.getByType('muscle_group'), isNotEmpty);
  });

  test('refresh fetches fresh catalog and updates state', () async {
    final fresh = MetadataCatalog(
      version: 10,
      updatedAt: DateTime(2026, 3, 1),
      catalog: {
        'equipment': [
          const MetadataItem(key: 'kettlebell', labelFa: 'کتل‌بل', labelEn: 'Kettlebell'),
        ],
      },
    );

    mockRepo.updatedCatalog = fresh;
    final notifier = container.read(metadataCatalogProvider.notifier);
    await notifier.refresh();

    final state = container.read(metadataCatalogProvider);
    expect(state.version, equals(10));
    expect(container.read(equipmentProvider).first.key, equals('kettlebell'));
  });
}
