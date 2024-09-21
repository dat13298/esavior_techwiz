import 'package:flutter/material.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:esavior_techwiz/services/booking_service.dart';

import '../../models/account.dart';
import 'admin_feedback.dart';
import 'admin_manager.dart';
import 'admin_profile.dart';
import 'customAppBar.dart';

class AdminPage extends StatefulWidget {
  final Account account;
  const AdminPage({super.key, required this.account});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with AutomaticKeepAliveClientMixin{
  late List<Widget> _tabs;
  int _currentIndex = 0;
  late Stream<List<Booking>> _bookingStream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _bookingStream = ;
    _tabs = [
      _buildHomeTab(), // Tab Home
      const FeedBackTab(), // Tab Activity
      const ManagerTab(), // Tab Manager
      ProfileTab(account: widget.account), // Tab Profile
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF10CCC6),
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              label: "Feedback",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: "Manager",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'eSavior',
        subtitle: 'Management',
        showBackButton: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${widget.account.fullName}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to dispatch ambulance page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF20202),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Dispatch an ambulance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Emergency booking',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Booking>>(
                future: BookingService().getBookingsByStatus('Not Yet Confirm'),
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

                  // Get the list of bookings with 'Not Yet Confirm' status
                  final bookings = snapshot.data!;

                  return ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text('Driver Phone: ${booking.driverPhoneNumber}'),
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
      ),
    );
  }



}
