import 'package:flutter/material.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:esavior_techwiz/services/booking_service.dart';
import 'custom_app_bar.dart';

class BookingManager extends StatefulWidget {
  const BookingManager({super.key});

  @override
  BookingManagerState createState() => BookingManagerState();
}

class BookingManagerState extends State<BookingManager> {
  final TextEditingController _searchController = TextEditingController();
  List<Booking> _allBookings = [];
  List<Booking> _filteredBookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final bookings = await BookingService().getAllBookings();
    setState(() {
      _allBookings = bookings;
      _filteredBookings = bookings;
    });
  }

  void _filterBookings(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredBookings = _allBookings;
      } else {
        _filteredBookings = _allBookings.where((booking) {
          return booking.userPhoneNumber!.contains(searchTerm) ||
              booking.driverPhoneNumber!.contains(searchTerm);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Booking Manager',
        subtitle: 'Manage all booking',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterBookings,
              decoration: InputDecoration(
                labelText: 'Search by User or Driver Phone Number',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterBookings('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Booking>>(
              future: BookingService().getAllBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bookings found'));
                }
                final bookings = _filteredBookings;
                return ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    Color cardColor;
                    switch (booking.status.toLowerCase()) {
                      case 'waiting':
                        cardColor = Colors.yellow[100]!;
                        break;
                      case 'completed':
                        cardColor = Colors.green[100]!;
                        break;
                      case 'not yet confirm':
                        cardColor = Colors.blue[100]!;
                        break;
                      default:
                        cardColor = Colors.grey[100]!;
                        break;
                    }
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      color: cardColor,
                      child: ListTile(
                        title:
                            Text('Driver Phone: ${booking.driverPhoneNumber}'),
                        subtitle: Text(
                          'User Phone: ${booking.userPhoneNumber}\n'
                          'Date: ${booking.formattedDateTime}',
                        ),
                        trailing: Text('Status: ${booking.status}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
