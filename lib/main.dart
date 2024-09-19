import 'package:esavior_techwiz/connection/firebase_connection.dart';
import 'package:esavior_techwiz/views/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // Đảm bảo Flutter framework được khởi tạo trước khi thực hiện các tác vụ async
  WidgetsFlutterBinding.ensureInitialized();

  // Kiểm tra và yêu cầu quyền truy cập vị trí
  if (await Permission.locationWhenInUse.isDenied) {
    await Permission.locationWhenInUse.request();
  }

  // Khởi tạo Firebase
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
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
