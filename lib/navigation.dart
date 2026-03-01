import 'package:flutter/material.dart';

NavigationBar buildNavigationBar() {
  return NavigationBar(
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      NavigationDestination(
        icon: Icon(Icons.person),
        label: "Profile",
      ),
    ],
    onDestinationSelected: (int value) {},
    selectedIndex: 0,
  );
}
