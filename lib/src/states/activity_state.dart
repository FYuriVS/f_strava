sealed class ActivityState {}

sealed class Location {
  double lat;
  double long;

  Location({required this.lat, required this.long});
}

class InitialActivityState extends ActivityState {}

class LoadingActivityState extends ActivityState {}

class ErrorActivityState extends ActivityState {
  final String message;
  ErrorActivityState(this.message);
}

class StartedActivityState extends ActivityState {
  final DateTime initialTime;
  StartedActivityState(this.initialTime);
}

class CompletedActivityState extends ActivityState {
  final String message;
  CompletedActivityState(this.message);
}

class CancelledActivityState extends ActivityState {
  final String message;
  CancelledActivityState(this.message);
}
