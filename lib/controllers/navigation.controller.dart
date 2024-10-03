import 'package:flutter/material.dart';

class NavigationNotifier extends ValueNotifier<int> {
  NavigationNotifier() : super(0);

  int get currentRoute => value;

  void changeRoute(int newRoute) {
    value = newRoute;
  }
}
