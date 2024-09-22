import 'package:flutter/material.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/map_controller.dart';
import '../../services/address_service.dart';

class BookingHistory extends StatefulWidget {
  final Account currentAccount;

  const BookingHistory({Key? key, required this.currentAccount}) : super(key: key);

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

  Future<void> fetchBookingList() async {
    try {
      print("Fetching bookings...");
      List<Booking> bookings = await BookingService().getBookingsByPhoneNumber(widget.currentAccount.phoneNumber);
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

  DateTime _convertTimestampToDateTime(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

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
          MaterialPageRoute(builder: (context) => DetailScreen(booking: booking, account: widget.currentAccount,)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: AppBar(
            automaticallyImplyLeading: false, // Bỏ nút back
            backgroundColor: const Color(0xFF10CCC6),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'eSavior',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  'Your health is our care!',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
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

class DetailScreen extends StatelessWidget {
  final Booking booking;
  final Account account;

  const DetailScreen({Key? key, required this.booking, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(booking.dateTime.seconds * 1000);
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedTime = "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    double? endLat = booking.endLatitude;
    double? endLong = booking.endLongitude;

    LatLng destinationLocation = LatLng(endLat!, endLong!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: const Color(0xFF10CCC6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${booking.type}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    const SizedBox(height: 10),
                    const Text('Destination:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    FutureBuilder<String>(
                      future: getAddressFromLatlon(destinationLocation),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Hiển thị khi đang tải
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? 'N/A', style: const TextStyle(fontSize: 16));
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Thực hiện hành động của bạn ở đây
                    showMapScreen(context, null,account, booking);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    backgroundColor: const Color(0xFF10CCC6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Show Map',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





