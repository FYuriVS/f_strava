import 'package:destrava/src/controllers/navigation.controller.dart';
import 'package:destrava/src/app_widget.dart';
import 'package:destrava/src/stores/location_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';

GetIt getIt = GetIt.instance;

void main() {
  runApp(const MyApp());
  setupDI();
}

void setupDI() {
  getIt.registerSingleton<NavigationNotifier>(NavigationNotifier(),
      instanceName: 'navigation');
  getIt.registerSingleton<LocationStore>(LocationStore(),
      instanceName: 'location');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapController mapController = MapController();
  Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AppWidget(),
    );
  }
}
