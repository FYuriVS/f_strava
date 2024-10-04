import 'package:destrava/src/controllers/navigation.controller.dart';
import 'package:destrava/main.dart';
import 'package:destrava/src/pages/activity_page.dart';
import 'package:destrava/src/pages/home_page.dart';
import 'package:destrava/src/pages/statistics_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final NavigationNotifier navigationNotifier =
      getIt.get(instanceName: 'navigation');

  @override
  void initState() {
    super.initState();
  }

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
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (notification) => false,
        leadingWidth: 190,
        title: const Text("Olá, Yuri Vital"),
        actions: [
          IconButton.outlined(onPressed: () {}, icon: const Icon(Icons.person))
        ],
      ),
      body: _buildPageView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ActivityPage(
                      title: '',
                    )),
          );
        },
        child: const Icon(Icons.directions_run),
      ),
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
