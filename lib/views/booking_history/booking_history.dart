import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:flutter/material.dart';

import '../../models/booking.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  List<Booking> bookingList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookingList();
  }

  // Method để lấy dữ liệu booking từ Firebase
  Future<void> fetchBookingList() async {
    try {
      print("Fetching bookings...");
      List<Booking> bookings = await BookingService().getBookingsByPhoneNumber('01222222222');
      print("Bookings fetched: ${bookings.length}");

      setState(() {
        bookingList = bookings;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  // Chuyển đổi timestamp thành DateTime
  DateTime _convertTimestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  // Widget để hiển thị từng mục booking
  Widget _buildBookingItem(Booking booking) {
    DateTime dateTime = _convertTimestampToDateTime(booking.dateTime.seconds);
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Icon(
        booking.type == "emergency" ? Icons.local_hospital : Icons.local_taxi,
        color: booking.type == "emergency" ? Colors.red : Colors.blue,
      ),
      title: Text(
        booking.type,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Date: $formattedDate - Time: $formattedTime"),
      trailing: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: booking.status == "completed"
              ? Colors.green.withOpacity(0.1)
              : booking.status == "waiting"
              ? Colors.orange.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          border: Border.all(
            color: booking.status == "completed"
                ? Colors.green
                : booking.status == "waiting"
                ? Colors.orange
                : Colors.red,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          booking.status.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: booking.status == "completed"
                ? Colors.green
                : booking.status == "waiting"
                ? Colors.orange
                : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
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
        title: const Text('Booking History'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingList.isEmpty
          ? const Center(child: Text('No bookings available'))
          : ListView.builder(
        itemCount: bookingList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: _buildBookingItem(bookingList[index]),
          );
        },
      ),
    );
  }
}

// Tạo màn hình chi tiết để hiển thị thông tin cụ thể của booking
class DetailScreen extends StatelessWidget {
  final Booking booking;

  const DetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(booking.dateTime.seconds * 1000);
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: Text('${booking.type} Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${booking.type}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Date: $formattedDate', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Time: $formattedTime', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Status: ${booking.status}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Driver Phone: ${booking.driverPhoneNumber}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('User Phone: ${booking.userPhoneNumber}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
