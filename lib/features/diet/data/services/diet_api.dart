import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitsho/features/diet/data/models/diet_models.dart';
import 'package:fitsho/shared/data/models/message_response.dart';

part 'diet_api.g.dart';

@RestApi()
abstract class DietApi {
  factory DietApi(Dio dio, {String baseUrl}) = _DietApi;

  @GET('/api/diet-profile/options')
  Future<DietProfileOptionsEnvelope> getProfileOptions();

  @GET('/api/diet-profile')
  Future<DietProfileEnvelope> getProfile();

  @PUT('/api/diet-profile')
  Future<DietProfileEnvelope> upsertProfile(
    @Body() UpsertDietProfileRequest body,
  );

  @GET('/api/diet-profile/meal-slots')
  Future<MealSlotsEnvelope> getMealSlots();

  @PUT('/api/diet-profile/meal-slots')
  Future<MealSlotsEnvelope> upsertMealSlots(
    @Body() UpsertMealSlotsRequest body,
  );

  @GET('/api/diet-plans')
  Future<DietPlanEnvelope> getActivePlan();

  @GET('/api/diet-plans/history')
  Future<DietPlanListEnvelope> getPlanHistory();

  @POST('/api/diet-plans/generate')
  Future<DietPlanEnvelope> generatePlan();

  @DELETE('/api/diet-plans/{id}')
  Future<MessageResponse> deletePlan(@Path('id') String id);

  @GET('/api/meal-logs/last')
  Future<MealLogEnvelope> getLastMealLog();

  @GET('/api/meal-logs/today')
  Future<MealLogListEnvelope> getTodayMealLogs();

  @GET('/api/meal-logs/stats')
  Future<ComplianceStatsEnvelope> getComplianceStats();

  @POST('/api/meal-logs')
  Future<MealLogEnvelope> logMeal(@Body() LogMealRequest body);

  @GET('/api/supplements')
  Future<SupplementListEnvelope> listSupplements();

  @POST('/api/supplements')
  Future<SupplementEnvelope> createSupplement(
    @Body() CreateSupplementRequest body,
  );

  @PATCH('/api/supplements/{id}')
  Future<SupplementEnvelope> updateSupplement(
    @Path('id') String id,
    @Body() UpdateSupplementRequest body,
  );

  @DELETE('/api/supplements/{id}')
  Future<MessageResponse> deleteSupplement(@Path('id') String id);

  @POST('/api/notifications/tokens')
  Future<MessageResponse> registerFcmToken(
    @Body() FcmTokenRegistrationRequest body,
  );

  @DELETE('/api/notifications/tokens/{token}')
  Future<MessageResponse> unregisterFcmToken(@Path('token') String token);
}
