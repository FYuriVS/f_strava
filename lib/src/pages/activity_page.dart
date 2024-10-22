import 'package:destrava/main.dart';
import 'package:destrava/src/models/route_model.dart';
import 'package:destrava/src/states/activity_state.dart';
import 'package:destrava/src/states/location_state.dart';
import 'package:destrava/src/stores/activity_store.dart';
import 'package:destrava/src/stores/location_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key, required this.title});

  final String title;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  MapController mapController = MapController();
  LocationStore locationStore = getIt.get(instanceName: 'location');
  ActivityStore activityStore =
      ActivityStore(getIt.get(instanceName: 'activityService'));
  LocationData? _locationData;
  bool initMap = false;
  DateTime? initialTime;
  List<RouteModel> completedRoute = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activityStore,
      builder: (context, value, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: ValueListenableBuilder(
            valueListenable: locationStore,
            builder: (context, value, child) {
              if (value is SuccessLocationState) {
                _locationData = value.location;
              }
              return Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        initialCenter: LatLng(_locationData?.latitude ?? 0,
                            _locationData?.longitude ?? 0),
                        initialZoom: 15.0),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(_locationData?.latitude ?? 0,
                                _locationData?.longitude ?? 0),
                            width: 10,
                            height: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primaryContainer),
                        fixedSize: const WidgetStatePropertyAll(
                          Size(10, 10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: activityStore,
            builder: (context, value, child) => SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          moveMarker();
                        },
                        child: const Icon(Icons.my_location),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primaryContainer),
                          fixedSize: const WidgetStatePropertyAll(
                            Size(100, 100),
                          ),
                        ),
                        onPressed: () {
                          value is InitialActivityState
                              ? initActivity(locationStore)
                              : completeActivity();
                        },
                        child: value is InitialActivityState
                            ? const Text(
                                "Iniciar",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            : const Text(
                                'Encerrar',
                                style: TextStyle(fontSize: 12),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  void initActivity(subscription) {
    activityStore.startActivity();

    initialTime = DateTime.now().toUtc();
    startTrackingLocation(subscription);
  }

  void startTrackingLocation(location) {
    location.locationService.location.onLocationChanged.listen(
      (LocationData locationData) {
        completedRoute.add(
          RouteModel(
            lat: locationData.latitude!,
            long: locationData.longitude!,
          ),
        );
      },
    );
  }

  void completeActivity() {
    activityStore.completeActivity(initialTime, completedRoute);
    activityStore.dispose();
  }

  void moveMarker() {
    mapController.move(
        LatLng(_locationData?.latitude ?? 0, _locationData?.longitude ?? 0),
        18);
  }
}
