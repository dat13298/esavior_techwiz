

import 'package:firebase_database/firebase_database.dart';

class AdminNotificationService{
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  void listenForNotifications() {
    _databaseReference.child('notifications/admin_notifications').onChildAdded.listen((event) {
      final notificationData = event.snapshot.value as Map<dynamic, dynamic>;
      final message = notificationData['message'] as String;
      // Xử lý thông báo, ví dụ: hiển thị thông báo cho quản trị viên
      print('Notification received: $message');
    });
  }
}