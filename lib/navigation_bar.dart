import 'package:flutter/material.dart';

NavigationBar buildNavigationBar(int selectedIndex, Function(int) onSelect) {
  return NavigationBar(
    backgroundColor: Colors.white,
    animationDuration: Duration(seconds: 2),
    selectedIndex: selectedIndex,
    destinations: [
      NavigationDestination(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      NavigationDestination(
        icon: Icon(Icons.dashboard),
        label: "Dashboard",
      ),
      NavigationDestination(
        icon: Icon(Icons.person),
        label: "Profile",
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_rounded),
        label: "Settings",
      ),
    ],
    onDestinationSelected: onSelect,
  );
}
