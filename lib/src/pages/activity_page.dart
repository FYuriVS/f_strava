import 'package:destrava/main.dart';
import 'package:destrava/src/states/location_state.dart';
import 'package:destrava/src/stores/location_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    locationStore.getLocation();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    options: const MapOptions(
                      initialZoom: 5,
                    ),
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
                      )
                    ],
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
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
            }),
        floatingActionButton: SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center, // Centraliza o FAB
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
                    onPressed: () {},
                    child: const Text(
                      "Iniciar",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void moveMarker() {
    mapController.move(
        LatLng(_locationData?.latitude ?? 0, _locationData?.longitude ?? 0),
        15);
  }
}
