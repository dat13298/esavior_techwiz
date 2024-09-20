import 'package:flutter/material.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  late Future<List<Map<String, dynamic>>> bookingList;

  @override
  void initState() {
    super.initState();
    // Tạo dữ liệu mẫu với timestamp
    bookingList = Future.delayed(Duration(seconds: 1), () {
      return [
        {
          "title": "Emergency",
          "dateTime": 1695100000000, // Timestamp mẫu
          "status": "completed"
        },
        {
          "title": "Non-Emergency",
          "dateTime": 1695013600000, // Timestamp mẫu
          "status": "waiting"
        },
        {
          "title": "Emergency",
          "dateTime": 1694927200000, // Timestamp mẫu
          "status": "rejected"
        },
      ];
    });
  }

  // Chuyển đổi timestamp thành DateTime
  DateTime _convertTimestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // Widget để hiển thị từng mục booking
  Widget _buildBookingItem(Map<String, dynamic> booking) {
    DateTime dateTime = _convertTimestampToDateTime(booking['dateTime']);
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Icon(
        booking['title'] == "Emergency" ? Icons.local_hospital : Icons.local_taxi,
        color: booking['title'] == "Emergency" ? Colors.red : Colors.blue,
      ),
      title: Text(
        booking['title'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Date: $formattedDate - Time: $formattedTime"),
      trailing: Container(
        width: 120,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: booking['status'] == "completed"
              ? Colors.green.withOpacity(0.1)
              : booking['status'] == "waiting"
              ? Colors.orange.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          border: Border.all(
            color: booking['status'] == "completed"
                ? Colors.green
                : booking['status'] == "waiting"
                ? Colors.orange
                : Colors.red,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          booking['status'].toString().toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: booking['status'] == "completed"
                ? Colors.green
                : booking['status'] == "waiting"
                ? Colors.orange
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Thêm hành động khi nhấn vào ListTile
      onTap: () {
        // Điều hướng đến màn hình chi tiết với thông tin booking
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(booking: booking),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: bookingList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading booking history'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings available'));
          }

          List<Map<String, dynamic>> bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: _buildBookingItem(bookings[index]),
              );
            },
          );
        },
      ),
    );
  }
}

// Tạo màn hình chi tiết để hiển thị thông tin cụ thể của booking
class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> booking;

  const DetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(booking['dateTime']);
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text('${booking['title']} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${booking['title']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Date: $formattedDate', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Time: $formattedTime', style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Status: ${booking['status']}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
