import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitsho/features/diet/data/models/diet_models.dart';
import 'package:fitsho/shared/data/models/message_response.dart';

part 'diet_api.g.dart';

@RestApi()
abstract class DietApi {
  factory DietApi(Dio dio, {String baseUrl}) = _DietApi;

  @GET('diet-profile/options')
  Future<DietProfileOptionsEnvelope> getProfileOptions();

  @GET('diet-profile')
  Future<DietProfileEnvelope> getProfile();

  @PUT('diet-profile')
  Future<DietProfileEnvelope> upsertProfile(
    @Body() UpsertDietProfileRequest body,
  );

  @PUT('diet-profile/meal-slots')
  Future<DietProfileEnvelope> upsertMealSlots(
    @Body() UpsertMealSlotsRequest body,
  );

  @GET('diet-plans')
  Future<DietPlanEnvelope> getActivePlan();

  @GET('diet-plans/history')
  Future<DietPlanListEnvelope> getPlanHistory();

  @POST('diet-plans/generate')
  Future<DietPlanEnvelope> generatePlan();

  @DELETE('diet-plans/{id}')
  Future<MessageResponse> deletePlan(@Path('id') String id);

  @GET('meal-logs/last')
  Future<MealLogEnvelope> getLastMealLog();

  @GET('meal-logs/today')
  Future<MealLogListEnvelope> getTodayMealLogs();

  @GET('meal-logs/stats')
  Future<ComplianceStatsEnvelope> getComplianceStats();

  @POST('meal-logs')
  Future<MealLogEnvelope> logMeal(@Body() LogMealRequest body);

  @GET('supplements')
  Future<SupplementListEnvelope> listSupplements();

  @POST('supplements')
  Future<SupplementEnvelope> createSupplement(
    @Body() CreateSupplementRequest body,
  );

  @PATCH('supplements/{id}')
  Future<SupplementEnvelope> updateSupplement(
    @Path('id') String id,
    @Body() UpdateSupplementRequest body,
  );

  @DELETE('supplements/{id}')
  Future<MessageResponse> deleteSupplement(@Path('id') String id);

  @POST('notifications/tokens')
  Future<MessageResponse> registerFcmToken(
    @Body() FcmTokenRegistrationRequest body,
  );

  @DELETE('notifications/tokens/{token}')
  Future<MessageResponse> unregisterFcmToken(@Path('token') String token);
}
