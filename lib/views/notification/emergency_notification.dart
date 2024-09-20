import 'package:flutter/material.dart';

class EmergencyNotification extends StatefulWidget {
  final String title; // Tiêu đề cho mức độ quan trọng
  final String message;
  final VoidCallback onConfirm;

  const EmergencyNotification({
    Key? key,
    required this.title, // Thêm tiêu đề
    required this.message,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _EmergencyNotificationState createState() => _EmergencyNotificationState();
}

class _EmergencyNotificationState extends State<EmergencyNotification> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hiển thị tiêu đề
                Text(
                  widget.title, // Hiển thị mức độ quan trọng
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10), // Khoảng cách giữa tiêu đề và nội dung
                Text(
                  widget.message,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        widget.onConfirm(); // Xác nhận
                        // Chỉ loại bỏ overlay, không gọi Navigator.of(context).pop()
                      },
                      child: Text("Confirm"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(); // Đóng thông báo khẩn cấp
                      },
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
