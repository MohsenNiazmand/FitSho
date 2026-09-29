import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fitsho/core/error/failures.dart';
import 'package:fitsho/core/metadata/default_catalog.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_catalog.dart';
import 'package:fitsho/core/metadata/domain/entities/metadata_item.dart';
import 'package:fitsho/core/metadata/domain/repositories/metadata_repository.dart';
import 'package:fitsho/core/metadata/data/datasources/metadata_local_datasource.dart';
import 'package:fitsho/core/metadata/data/datasources/metadata_remote_datasource.dart';

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
    return DefaultCatalog.asCatalog();
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
        await localDatasource.clearCache();
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

  @override
  Future<Either<Failure, MetadataCatalog>> fetchFreshCatalog() async {
    try {
      final res = await remoteDatasource.fetchCatalog();
      final entity = res.toEntity();
      if (entity != null) {
        await localDatasource.cacheCatalog(entity);
        return right(entity);
      }
      return left(const ServerFailure('داده‌های کاتالوگ نامعتبر است'));
    } on DioException catch (e) {
      return left(ServerFailure(e.message ?? 'خطا در دریافت کاتالوگ'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
