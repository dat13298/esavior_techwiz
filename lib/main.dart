import 'package:esavior_techwiz/connection/firebase_connection.dart';
import 'package:esavior_techwiz/views/map_screen.dart';
import 'package:esavior_techwiz/views/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controllers/map_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  await FirestoreService.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showMapScreen(context); // Mở MapScreen khi nút bấm
          },
          child: Text('Show Map'),
        ),
      ),
    );
  }
}

