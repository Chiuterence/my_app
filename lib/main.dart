import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Demo'),
            centerTitle: true,
            backgroundColor: Colors.teal
          ),
          drawer: SafeArea(
            child: Drawer(
              backgroundColor: Colors.white,
               child: Column(
                children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      iconColor: Colors.black,
                      title: Text('Home'),
                      textColor: Colors.black,
                      onTap: () {},
                    ),
                ],
                ),
                ),
          ),
          body: const Center(
            child: Text(
              "Hello World",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: NavigationBar(
            destinations: [
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
          ),
      ),
      ); 
  }
}

