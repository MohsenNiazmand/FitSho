import 'metadata_item.dart';

class MetadataCatalog {
  const MetadataCatalog({
    required this.version,
    required this.updatedAt,
    required this.catalog,
  });

  final int version;
  final DateTime updatedAt;
  final Map<String, List<MetadataItem>> catalog;

  List<MetadataItem> getByType(String type) {
    return catalog[type] ?? const [];
  }

  MetadataItem? findByKey(String type, String key) {
    final list = getByType(type);
    for (final item in list) {
      if (item.key == key) return item;
    }
    return null;
  }
}
