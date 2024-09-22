import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/map_controller.dart';
import '../../services/address_service.dart';

class BookingHistory extends StatefulWidget {
  final Account currentAccount;

  const BookingHistory({super.key, required this.currentAccount});

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
      if (kDebugMode) {
        print("Fetching bookings...");
      }
      List<Booking> bookings = await BookingService()
          .getBookingsByPhoneNumber(widget.currentAccount.phoneNumber);
      if (kDebugMode) {
        print("Bookings fetched: ${bookings.length}");
      }

      setState(() {
        bookingList = bookings;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching bookings: $e");
      }
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
    String formattedTime =
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

    // Cập nhật màu sắc dựa trên trạng thái
    Color backgroundColor;
    Color borderColor;
    Color textColor;

    if (booking.status == "Completed") {
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
      textColor = Colors.green;
    } else if (booking.status == "Not Yet Confirm") {
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red;
      textColor = Colors.red;
    } else {
      backgroundColor = Colors.orange.withOpacity(0.1);
      borderColor = Colors.orange;
      textColor = Colors.orange;
    }

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
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          booking.status.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(
                booking: booking,
                account: widget.currentAccount,
              )),
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
            automaticallyImplyLeading: false,
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      child: _buildBookingItem(bookingList[index]),
                    );
                  },
                ),
    );
  }
}

class DetailScreen extends StatefulWidget {
  final Booking booking;
  final Account account;

  const DetailScreen({super.key, required this.booking, required this.account});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String formattedDate;
  late String formattedTime;
  String? startAddress;
  String? endAddress;

  @override
  void initState() {
    super.initState();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        widget.booking.dateTime.seconds * 1000);
    formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    formattedTime =
        "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    _convertAddressToDisplay();
  }

  @override
  Widget build(BuildContext context) {
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
                    Text('Title: ${widget.booking.type}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Date: $formattedDate',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('Time: $formattedTime',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('Status: ${widget.booking.status}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('Driver Phone: ${widget.booking.driverPhoneNumber}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('User Phone: ${widget.booking.userPhoneNumber}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    const Text('Start Address:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      startAddress ?? 'Loading...',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    const Text('End Address:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      endAddress ?? 'Loading...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showMapScreen(
                            context, null, widget.account, widget.booking);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        backgroundColor: const Color(0xFF10CCC6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Show Map',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (widget.account.role == 'driver')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          BookingService().updateBookingStatus(
                              widget.booking.id, "Completed");
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Completed',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _convertAddressToDisplay() async {
    if (kDebugMode) {
      print(
        "Start Latitude: ${widget.booking.startLatitude}, Start Longitude: ${widget.booking.startLongitude}");
    }
    if (kDebugMode) {
      print(
        "End Latitude: ${widget.booking.endLatitude}, End Longitude: ${widget.booking.endLongitude}");
    }

    String startAddress = await getAddressFromLatlon(
        LatLng(widget.booking.startLatitude!, widget.booking.startLongitude!));
    String endAddress = await getAddressFromLatlon(
        LatLng(widget.booking.endLatitude!, widget.booking.endLongitude!));

    setState(() {
      startAddress = startAddress;
      endAddress = endAddress;
    });
  }
}
