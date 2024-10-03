import 'package:f_strava/controllers/navigation.controller.dart';
import 'package:f_strava/pages/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void main() {
  runApp(const MyApp());
  setupDI();
}

void setupDI() {
  getIt.registerSingleton<NavigationNotifier>(NavigationNotifier(),
      instanceName: 'navigation');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppWidget(),
    );
  }
}
