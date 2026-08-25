import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitsho/features/preferences/data/models/preference_model.dart';
import 'package:fitsho/shared/data/models/message_response.dart';

part 'preference_api.g.dart';

@RestApi()
abstract class PreferenceApi {
  factory PreferenceApi(Dio dio, {String baseUrl}) = _PreferenceApi;

  @GET('/api/preferences')
  Future<PreferenceEnvelope> getPreferences();

  @PUT('/api/preferences')
  Future<PreferenceEnvelope> upsertPreferences(
    @Body() UpsertPreferenceRequest body,
  );

  @DELETE('/api/preferences')
  Future<MessageResponse> deletePreferences();
}
