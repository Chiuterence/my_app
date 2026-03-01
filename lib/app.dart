import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'drawer.dart';
import 'navigation.dart';

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
        appBar: buildAppBar(),
        drawer: buildDrawer(),
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
        bottomNavigationBar: buildNavigationBar(),
      ),
    );
  }
}
