import 'package:esavior_techwiz/services/drver_service.dart';
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
                showBookingsToDispatch(context);
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

  void showBookingsToDispatch(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Booking to Dispatch'),
          content: Container(
            width: 300, // Đặt chiều rộng tùy ý
            constraints: const BoxConstraints(maxHeight: 400), // Giới hạn chiều cao tối đa
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
                  return const Center(child: Text('No bookings available'));
                }

                final bookings = snapshot.data!;
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true, // Để ListView không chiếm hết không gian
                    physics: const NeverScrollableScrollPhysics(), // Ngăn chặn cuộn
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return ListTile(
                        title: Text('User Phone: ${booking.userPhoneNumber}'),
                        subtitle: Text('Date: ${booking.formattedDateTime}'),
                        onTap: () {
                          // Khi chọn booking, mở danh sách tài xế
                          Navigator.pop(context);
                          showDriversToAssign(context, booking, index);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showDriversToAssign(BuildContext context, Booking booking, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Driver'),
          content: Container(
            width: 300, // Đặt chiều rộng tùy ý
            constraints: const BoxConstraints(maxHeight: 400), // Giới hạn chiều cao tối đa
            child: StreamBuilder<List<Account>>(
              stream: DriverService().getAllDriver(), // Sử dụng stream để lấy tài xế
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No drivers available'));
                }

                final drivers = snapshot.data!;
                return SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true, // Để ListView không chiếm hết không gian
                    physics: const NeverScrollableScrollPhysics(), // Ngăn chặn cuộn
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      return ListTile(
                        title: Text(driver.fullName),
                        subtitle: Text(driver.phoneNumber),
                        onTap: () async {
                          // Cập nhật booking với tài xế được chọn
                          await BookingService().updateBooking(booking.id, driver.phoneNumber);

                          // Cập nhật trạng thái booking thành "Waiting"
                          await BookingService().updateBookingStatus(booking.id, 'Waiting');

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Driver assigned successfully!')),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }





}
