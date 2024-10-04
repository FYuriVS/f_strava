import 'package:location/location.dart';

class LocationService {
  final Location location;

  LocationService(this.location);

  Future<LocationData> getLocation() async {
    final response = await location.getLocation();
    return response;
  }
}
