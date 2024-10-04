import 'package:location/location.dart';

sealed class LocationState {}

class InitialLocationState extends LocationState {}

//Success
class SuccessLocationState extends LocationState {
  final LocationData location;
  SuccessLocationState(this.location);
}

//Loading
class LoadingLocationState extends LocationState {}

//Error
class ErrorLocationState extends LocationState {
  final String message;
  ErrorLocationState(this.message);
}
