import 'package:esavior_techwiz/views/driver/car_manager_screen.dart';
import 'package:esavior_techwiz/views/home/profile_tab.dart';
import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../booking_history/booking_history.dart';

class DriverPage extends StatefulWidget {
  final Account account;

  const DriverPage({super.key, required this.account});

  @override
  DriverHomeStage createState() => DriverHomeStage();
}

class DriverHomeStage extends State<DriverPage> {
  late List<Widget> _tabs;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = [
      DriverHomeTab(account: widget.account,),
      CarManagerScreen(account: widget.account),
      ProfileUserTab(account: widget.account),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.car_crash_sharp), label: "Activity"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

class DriverHomeTab extends StatefulWidget {
  final Account account;

  const DriverHomeTab({super.key, required this.account});

  @override
  State<DriverHomeTab> createState() => _DriverHomeTabStateState();
}

class _DriverHomeTabStateState extends State<DriverHomeTab> {
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
      List<Booking> bookings = await BookingService().getBookingsByDriverPhoneNumber(widget.account.phoneNumber);
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
                Text('eSavior', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                Text('Your health is our care!', style: TextStyle(fontSize: 20)),
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
          MaterialPageRoute(builder: (context) => DetailScreen(booking: booking, account: widget.account,)),
        );
      },
    );
  }


}

class AmbulanceCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const AmbulanceCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
