import 'dart:async';
import 'package:destrava/src/services/activity_service.dart';
import 'package:destrava/src/states/activity_state.dart';
import 'package:flutter/material.dart';

class ActivityStore extends ValueNotifier<ActivityState> {
  final ActivityService activityService;
  StreamSubscription? activitySubscription;

  ActivityStore(this.activityService) : super(InitialActivityState());
  Future<void> startActivity() async {
    value = LoadingActivityState();
    await Future.delayed(const Duration(seconds: 3));
    value = StartedActivityState(DateTime.now().toUtc());
  }

  Future<void> completeActivity(initialTime, route) async {
    value = LoadingActivityState();

    try {
      activityService.saveActivity(initialTime, route);
      value = CompletedActivityState("Atividade concluida!");
    } catch (e) {
      value = ErrorActivityState("Erro ao concluir a atividade");
    }
  }

  @override
  void dispose() {
    activitySubscription?.cancel();
    super.dispose();
  }
}
