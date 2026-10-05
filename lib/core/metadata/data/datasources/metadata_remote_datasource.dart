import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/metadata_item_model.dart';

part 'metadata_remote_datasource.g.dart';

@RestApi()
abstract class MetadataRemoteDatasource {
  factory MetadataRemoteDatasource(Dio dio, {String baseUrl}) = _MetadataRemoteDatasource;

  @GET('metadata')
  Future<MetadataCatalogResponseModel> fetchCatalog({
    @Query('version') int? version,
  });

  @GET('metadata/version')
  Future<MetadataVersionResponseModel> checkVersion();
}
