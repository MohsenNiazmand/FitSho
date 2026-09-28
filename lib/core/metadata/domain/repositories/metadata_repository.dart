import 'package:fpdart/fpdart.dart';
import '../../error/failures.dart';
import '../entities/metadata_catalog.dart';

abstract class MetadataRepository {
  Future<MetadataCatalog> getInitialCatalog();
  Future<Either<Failure, int>> checkVersion();
  Future<Either<Failure, MetadataCatalog?>> syncCatalogIfNeeded(int currentVersion);
}
