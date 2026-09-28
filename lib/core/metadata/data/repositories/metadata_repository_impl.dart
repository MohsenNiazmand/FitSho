import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../error/failures.dart';
import '../../metadata/default_catalog.dart';
import '../../domain/entities/metadata_catalog.dart';
import '../../domain/entities/metadata_item.dart';
import '../../domain/repositories/metadata_repository.dart';
import '../datasources/metadata_local_datasource.dart';
import '../datasources/metadata_remote_datasource.dart';

class MetadataRepositoryImpl implements MetadataRepository {
  const MetadataRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  final MetadataRemoteDatasource remoteDatasource;
  final MetadataLocalDatasource localDatasource;

  @override
  Future<MetadataCatalog> getInitialCatalog() async {
    final cached = await localDatasource.getCachedCatalog();
    if (cached != null) {
      return cached;
    }

    // Fallback to static DefaultCatalog
    final fallbackMap = <String, List<MetadataItem>>{};
    DefaultCatalog.catalog.forEach((key, list) {
      fallbackMap[key] = list.map((item) {
        return MetadataItem(
          key: item['key']?.toString() ?? '',
          labelFa: item['labelFa']?.toString() ?? '',
          labelEn: item['labelEn']?.toString() ?? '',
          icon: item['icon']?.toString(),
          order: (item['order'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    });

    return MetadataCatalog(
      version: DefaultCatalog.defaultVersion,
      updatedAt: DateTime(2026, 1, 1),
      catalog: fallbackMap,
    );
  }

  @override
  Future<Either<Failure, int>> checkVersion() async {
    try {
      final res = await remoteDatasource.checkVersion();
      return right(res.version);
    } on DioException catch (e) {
      return left(ServerFailure(e.message ?? 'خطا در بررسی نسخه متادیتا'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MetadataCatalog?>> syncCatalogIfNeeded(int currentVersion) async {
    try {
      final res = await remoteDatasource.fetchCatalog(version: currentVersion);
      if (res.upToDate) {
        return right(null);
      }

      final entity = res.toEntity();
      if (entity != null) {
        await localDatasource.cacheCatalog(entity);
        return right(entity);
      }

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure(e.message ?? 'خطا در همگام‌سازی متادیتا'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
