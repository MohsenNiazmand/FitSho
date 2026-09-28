import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/metadata_catalog.dart';
import '../../domain/entities/metadata_item.dart';

part 'metadata_item_model.g.dart';

@JsonSerializable()
class MetadataItemModel {
  const MetadataItemModel({
    required this.key,
    required this.labelFa,
    required this.labelEn,
    this.icon,
    this.order = 0,
  });

  factory MetadataItemModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataItemModelToJson(this);

  final String key;
  final String labelFa;
  final String labelEn;
  final String? icon;
  final int order;

  MetadataItem toEntity() {
    return MetadataItem(
      key: key,
      labelFa: labelFa,
      labelEn: labelEn,
      icon: icon,
      order: order,
    );
  }
}

@JsonSerializable()
class MetadataCatalogResponseModel {
  const MetadataCatalogResponseModel({
    required this.success,
    this.upToDate = false,
    this.version = 1,
    this.updatedAt,
    this.catalog,
  });

  factory MetadataCatalogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataCatalogResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataCatalogResponseModelToJson(this);

  final bool success;
  final bool upToDate;
  final int version;
  final String? updatedAt;
  final Map<String, List<MetadataItemModel>>? catalog;

  MetadataCatalog? toEntity() {
    if (upToDate || catalog == null) return null;
    final mapped = <String, List<MetadataItem>>{};
    catalog!.forEach((k, v) {
      mapped[k] = v.map((m) => m.toEntity()).toList();
    });
    return MetadataCatalog(
      version: version,
      updatedAt: DateTime.tryParse(updatedAt ?? '') ?? DateTime.now(),
      catalog: mapped,
    );
  }
}

@JsonSerializable()
class MetadataVersionResponseModel {
  const MetadataVersionResponseModel({
    required this.success,
    required this.version,
    this.updatedAt,
  });

  factory MetadataVersionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MetadataVersionResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataVersionResponseModelToJson(this);

  final bool success;
  final int version;
  final String? updatedAt;
}
