import 'package:destrava/src/controllers/navigation.controller.dart';
import 'package:destrava/src/app_widget.dart';
import 'package:destrava/src/pages/signin_page.dart';
import 'package:destrava/src/pages/signup_page.dart';
import 'package:destrava/src/services/activity_service.dart';
import 'package:destrava/src/stores/location_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://shjtlccxnekvnpvzdhcv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNoanRsY2N4bmVrdm5wdnpkaGN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg5NTIyMjcsImV4cCI6MjA0NDUyODIyN30.n8LqbeMjo6LrSDboOb6f8m7Tvy7lY1Je3VQYA9l0ySE',
  );
  setupDI();
  runApp(const MyApp());
}

void setupDI() {
  getIt.registerSingleton<NavigationNotifier>(NavigationNotifier(),
      instanceName: 'navigation');
  getIt.registerSingleton<LocationStore>(LocationStore(),
      instanceName: 'location');
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<ActivityService>(
      ActivityService(getIt.get<SupabaseClient>()),
      instanceName: 'activityService');
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
      home: const SignInPage(),
    );
  }
}
