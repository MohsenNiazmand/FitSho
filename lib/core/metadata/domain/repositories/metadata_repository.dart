import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import '../entities/metadata_catalog.dart';

abstract class MetadataRepository {
  Future<MetadataCatalog> getInitialCatalog();
  Future<Either<Failure, int>> checkVersion();
  Future<Either<Failure, MetadataCatalog?>> syncCatalogIfNeeded(int currentVersion);
  Future<Either<Failure, MetadataCatalog>> fetchFreshCatalog();
}
