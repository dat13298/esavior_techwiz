import 'package:esavior_techwiz/connection/firebase_connection.dart';
import 'package:esavior_techwiz/views/about/about.dart';
import 'package:esavior_techwiz/views/home/homepage.dart';
import 'package:esavior_techwiz/views/map_screen.dart';
import 'package:esavior_techwiz/views/profile/profile.dart';
import 'package:esavior_techwiz/views/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  await FirestoreService.initializeFirebase();

  runApp(AboutPage());
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
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}