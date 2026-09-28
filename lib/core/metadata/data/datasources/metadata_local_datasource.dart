import 'dart:convert';
import 'package:fitsho/core/storage/hive_initializer.dart';
import '../../domain/entities/metadata_catalog.dart';
import '../../domain/entities/metadata_item.dart';

abstract class MetadataLocalDatasource {
  Future<MetadataCatalog?> getCachedCatalog();
  Future<int?> getCachedVersion();
  Future<void> cacheCatalog(MetadataCatalog catalog);
  Future<void> clearCache();
}

class MetadataLocalDatasourceImpl implements MetadataLocalDatasource {
  static const _catalogKey = 'cached_catalog_json';
  static const _versionKey = 'cached_metadata_version';
  static const _updatedAtKey = 'cached_metadata_updated_at';

  @override
  Future<MetadataCatalog?> getCachedCatalog() async {
    try {
      final box = await HiveInitializer.openMetadataBox();
      final jsonString = box.get(_catalogKey) as String?;
      final version = box.get(_versionKey) as int?;
      final updatedAtString = box.get(_updatedAtKey) as String?;

      if (jsonString == null || version == null) {
        return null;
      }

      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final catalogMap = <String, List<MetadataItem>>{};
      decoded.forEach((key, list) {
        if (list is List) {
          catalogMap[key] = list.map((item) {
            final m = item as Map<String, dynamic>;
            return MetadataItem(
              key: m['key']?.toString() ?? '',
              labelFa: m['labelFa']?.toString() ?? '',
              labelEn: m['labelEn']?.toString() ?? '',
              icon: m['icon']?.toString(),
              order: (m['order'] as num?)?.toInt() ?? 0,
            );
          }).toList();
        }
      });

      return MetadataCatalog(
        version: version,
        updatedAt: DateTime.tryParse(updatedAtString ?? '') ?? DateTime.now(),
        catalog: catalogMap,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<int?> getCachedVersion() async {
    try {
      final box = await HiveInitializer.openMetadataBox();
      return box.get(_versionKey) as int?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheCatalog(MetadataCatalog catalog) async {
    try {
      final box = await HiveInitializer.openMetadataBox();
      final serializableMap = <String, List<Map<String, dynamic>>>{};

      catalog.catalog.forEach((key, items) {
        serializableMap[key] = items.map((item) => {
          'key': item.key,
          'labelFa': item.labelFa,
          'labelEn': item.labelEn,
          'icon': item.icon,
          'order': item.order,
        }).toList();
      });

      await box.put(_catalogKey, jsonEncode(serializableMap));
      await box.put(_versionKey, catalog.version);
      await box.put(_updatedAtKey, catalog.updatedAt.toIso8601String());
    } catch (_) {}
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await HiveInitializer.openMetadataBox();
      await box.delete(_catalogKey);
      await box.delete(_versionKey);
      await box.delete(_updatedAtKey);
    } catch (_) {}
  }
}
