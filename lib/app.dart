import 'package:flutter/material.dart';
import 'package:my_app/Pages/home_page.dart';
import 'app_bar.dart';
import 'drawer.dart';
import 'navigation_bar.dart';
import 'Pages/dashboard_page.dart';
import 'Pages/profile_page.dart';
import 'Pages/settings_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  // this method updates the new selected index of the navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // the pages we have in our app
  final List _pages = [
    const HomePage(),
    const DashboardPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          surface: Colors.grey[200]!,
        ),
      ),
      
  // this is the main scaffold of our app, it contains the app bar, drawer, body and navigation bar
      home: Scaffold(
        appBar: buildAppBar(),
        //drawer: buildDrawer(),
        body: _pages[_selectedIndex],        
        bottomNavigationBar: SizedBox(
          height: 100,
          child: buildNavigationBar(_selectedIndex, (int index) {
            setState(() => _selectedIndex = index);
          }),
        ),
      ),
    );
  }
}
