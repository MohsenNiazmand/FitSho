import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:fitsho/features/workout/data/models/workout_models.dart';
import 'package:fitsho/shared/data/models/message_response.dart';

part 'workout_api.g.dart';

@RestApi()
abstract class WorkoutApi {
  factory WorkoutApi(Dio dio, {String baseUrl}) = _WorkoutApi;

  @GET('workout-profile/options')
  Future<WorkoutOptionsEnvelope> getProfileOptions();

  @GET('workout-profile')
  Future<WorkoutProfileEnvelope> getProfile();

  @PUT('workout-profile')
  Future<WorkoutProfileEnvelope> upsertProfile(
    @Body() UpsertWorkoutProfileRequest body,
  );

  @POST('workout-plans/generate')
  Future<WorkoutPlanEnvelope> generatePlan();

  @GET('workout-plans')
  Future<WorkoutPlanEnvelope> getActivePlan();

  @GET('workout-plans/history')
  Future<WorkoutPlanHistoryEnvelope> getPlanHistory(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @DELETE('workout-plans/{id}')
  Future<MessageResponse> deletePlan(@Path('id') String id);

  @POST('workout-plans/{id}/swap-exercise')
  Future<SwapExerciseEnvelope> swapExercise(
    @Path('id') String id,
    @Body() SwapExerciseRequest body,
  );
}
