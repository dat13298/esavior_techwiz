import 'package:esavior_techwiz/connection/firebase_connection.dart';
import 'package:esavior_techwiz/views/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  await Permission.locationWhenInUse.isDenied.then((value) {
    if(value){
      Permission.locationWhenInUse.request();
    }
  });
  WidgetsFlutterBinding.ensureInitialized();
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
          useMaterial3: true
      ),
      home: MapScreen(),
      // home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}