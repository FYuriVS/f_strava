import 'dart:async';

import 'package:destrava/src/services/location_service.dart';
import 'package:destrava/src/states/location_state.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationStore extends ValueNotifier<LocationState> {
  LocationService locationService = LocationService(Location());
  StreamSubscription<LocationData>? _locationSubscription;

  LocationStore() : super(InitialLocationState()) {
    _listenToLocationChanges();
  }

  Future getLocation() async {
    value = InitialLocationState();
    value = LoadingLocationState();

    try {
      final location = await locationService.getLocation();
      value = SuccessLocationState(location);
    } catch (e) {
      value = ErrorLocationState("Erro ao capturar localicação");
    }
  }

  Future setLocation(LocationData location) async {
    value = LoadingLocationState();
    try {
      value = SuccessLocationState(location);
    } catch (e) {
      value = ErrorLocationState("Erro ao capturar localicação");
    }
  }

  void _listenToLocationChanges() {
    _locationSubscription = locationService.location.onLocationChanged.listen(
      (LocationData newLocation) {
        value = SuccessLocationState(newLocation);
      },
      onError: (e) {
        value = ErrorLocationState("Erro ao capturar mudanças de localização");
      },
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
