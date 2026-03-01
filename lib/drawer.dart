import 'package:flutter/material.dart';

Drawer buildDrawer() {
  return Drawer(
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            iconColor: Colors.black,
            title: const Text('Home'),
            textColor: Colors.black,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
