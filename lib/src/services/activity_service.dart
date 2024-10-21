import 'package:destrava/src/models/route_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ActivityService {
  final SupabaseClient supabaseClient;

  ActivityService(this.supabaseClient);

  Future<void> saveActivity(DateTime startTime, List<RouteModel> route) async {
    Duration duration = DateTime.now().toUtc().difference(startTime);
    int durationInSeconds = duration.inSeconds;

    await supabaseClient.from('activities').insert({
      'user_id': "",
      'activity_type': 'run',
      'distance_km': 0.0,
      'duration_seconds': durationInSeconds,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': DateTime.now().toUtc().toIso8601String(),
      'route': route,
    });
  }

  Future<void> cancelActivity(String activityId) async {
    final response = await supabaseClient
        .from('activities')
        .delete()
        .match({'id': activityId});

    if (response.error != null) {
      throw Exception(
          "Erro ao cancelar a atividade: ${response.error!.message}");
    }
  }
}
