import 'package:firebase_database/firebase_database.dart';

import '../views/notification/emergency_notification.dart';

class AdminNotificationService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final Function(String) onTabChanged; // Callback để theo dõi tab hiện tại

  AdminNotificationService(this.onTabChanged);

  void listenForNotifications() {
    _databaseReference.child('notifications/admin_notifications').onChildAdded.listen((event) {
      final notificationData = event.snapshot.value as Map<dynamic, dynamic>;
      final message = notificationData['message'] as String;

      // Gọi callback để lấy tab hiện tại
      String currentTab = onTabChanged(''); // Truyền tham số rỗng hoặc giá trị nào đó

      // Kiểm tra tab hiện tại
      if (currentTab == 'ADMIN_TAB') { // Thay YOUR_ADMIN_TAB bằng tên tab bạn muốn
        EmergencyNotification;
      }
    });
  }
}
