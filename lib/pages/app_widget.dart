import 'package:f_strava/controllers/navigation.controller.dart';
import 'package:f_strava/main.dart';
import 'package:f_strava/pages/activity_page.dart';
import 'package:f_strava/pages/home_page.dart';
import 'package:f_strava/pages/statistics_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final NavigationNotifier navigationNotifier =
      getIt.get(instanceName: 'navigation');

  int currentPageIndex = 0;

  final PageController _pageController = PageController();

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      currentPageIndex = selectedScreen;
      navigationNotifier.changeRoute(selectedScreen);
      _pageController.jumpToPage(selectedScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    NavigationDestinationLabelBehavior labelBehavior =
        NavigationDestinationLabelBehavior.alwaysShow;
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (notification) => false,
        title: const Text("Olá... Até onde iremos hoje?"),
      ),
      body: _buildPageView(),
    );
  }

  Widget _buildPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: const <Widget>[
        HomePage(),
        StatisticsPage(),
      ],
    );
  }
}
