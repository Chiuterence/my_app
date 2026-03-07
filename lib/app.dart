import 'package:flutter/material.dart';
import 'package:my_app/Pages/home_page.dart';
import 'app_bar.dart';
import 'drawer.dart';
import 'navigation_bar.dart';
import 'Pages/dashboard_page.dart';
import 'Pages/login_page.dart';
import 'Pages/profile_page.dart';
import 'Pages/settings_page.dart';
import 'services/auth_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  bool _isAuthenticated = false;
  String? _loggedInUser;

  final AuthService _authService = AuthService();

  // the pages we have in our app
  final List _pages = [
    const HomePage(),
    const DashboardPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  void _onLogin(String username) {
    setState(() {
      _isAuthenticated = true;
      _loggedInUser = username;
      _selectedIndex = 0;
    });
  }

  void _onLogout() {
    setState(() {
      _isAuthenticated = false;
      _loggedInUser = null;
      _selectedIndex = 0;
    });
  }

  @override
  void dispose() {
    _authService.close();
    super.dispose();
  }

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
      home: _isAuthenticated
          // this is the main scaffold of our app, it contains the app bar, drawer, body and navigation bar
          ? Scaffold(
              appBar: buildAppBar(
                loggedInUser: _loggedInUser,
                onLogout: _onLogout,
              ),
              //drawer: buildDrawer(),
              body: _pages[_selectedIndex],
              bottomNavigationBar: SizedBox(
                height: 100,
                child: buildNavigationBar(_selectedIndex, (int index) {
                  setState(() => _selectedIndex = index);
                }),
              ),
            )
          : LoginPage(
              authService: _authService,
              onLogin: _onLogin,
            ),
    );
  }
}
