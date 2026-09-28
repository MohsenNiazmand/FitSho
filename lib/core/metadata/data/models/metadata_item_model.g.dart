// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetadataItemModel _$MetadataItemModelFromJson(Map<String, dynamic> json) =>
    MetadataItemModel(
      key: json['key'] as String,
      labelFa: json['labelFa'] as String,
      labelEn: json['labelEn'] as String,
      icon: json['icon'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MetadataItemModelToJson(MetadataItemModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'labelFa': instance.labelFa,
      'labelEn': instance.labelEn,
      'icon': instance.icon,
      'order': instance.order,
    };

MetadataCatalogResponseModel _$MetadataCatalogResponseModelFromJson(
  Map<String, dynamic> json,
) => MetadataCatalogResponseModel(
  success: json['success'] as bool,
  upToDate: json['upToDate'] as bool? ?? false,
  version: (json['version'] as num?)?.toInt() ?? 1,
  updatedAt: json['updatedAt'] as String?,
  catalog: (json['catalog'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => MetadataItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
);

Map<String, dynamic> _$MetadataCatalogResponseModelToJson(
  MetadataCatalogResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'upToDate': instance.upToDate,
  'version': instance.version,
  'updatedAt': instance.updatedAt,
  'catalog': instance.catalog,
};

MetadataVersionResponseModel _$MetadataVersionResponseModelFromJson(
  Map<String, dynamic> json,
) => MetadataVersionResponseModel(
  success: json['success'] as bool,
  version: (json['version'] as num).toInt(),
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$MetadataVersionResponseModelToJson(
  MetadataVersionResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'version': instance.version,
  'updatedAt': instance.updatedAt,
};
