import 'dart:async';
import 'package:destrava/src/services/activity_servide.dart';
import 'package:destrava/src/states/activity_state.dart';
import 'package:flutter/material.dart';

class ActivityStore extends ValueNotifier<ActivityState> {
  final ActivityService activityService;
  StreamSubscription? _activitySubscription;

  ActivityStore(this.activityService) : super(InitialActivityState());
  Future<void> startActivity() async {
    value = LoadingActivityState();
    await Future.delayed(const Duration(seconds: 3));
    value = StartedActivityState(DateTime.now().toUtc());
  }

  Future<void> completeActivity(initialTime) async {
    value = LoadingActivityState();

    try {
      activityService.saveActivity(initialTime);
      value = CompletedActivityState("Atividade concluida!");
    } catch (e) {
      value = ErrorActivityState("Erro ao concluir a atividade");
    }
  }

  @override
  void dispose() {
    _activitySubscription?.cancel();
    super.dispose();
  }
}
