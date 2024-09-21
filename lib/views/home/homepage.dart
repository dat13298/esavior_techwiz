import 'package:esavior_techwiz/views/home/profile_tab.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../booking_history/booking_history.dart';
import 'notifications.dart';

class HomePage extends StatefulWidget {
  final Account account;

  const HomePage({super.key, required this.account});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<Widget>
      _tabs; // Dùng late để đảm bảo _tabs được khởi tạo trước khi sử dụng
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Khởi tạo _tabs trong initState
    _tabs = [
      const HomeTabState(), // Tab Home
      BookingHistory(currentAccount: widget.account), // Tab Activity
      Notifications(account: widget.account), // Tab Manager
      ProfileUserTab(account: widget.account), // Tab Profile
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Đảm bảo _tabs đã được khởi tạo trước khi sử dụng
    return Scaffold(
      body: _tabs[_currentIndex], // Sử dụng _tabs sau khi khởi tạo
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
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: "Activity",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Manager",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}

class HomeTabState extends StatefulWidget {
  const HomeTabState({super.key});

  @override
  State<HomeTabState> createState() => _HomeTabStateState();
}

class _HomeTabStateState extends State<HomeTabState> {
  bool showSeeMore = false;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search places',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Emergency button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Emergency button action
                },
                child: const Text(
                  'Call emergency',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            //TODO: code của Huy ở đây nhé Huy sửa lại giúp anh cho đúng với code cũ của Huy nhé
            // Ambulance gallery
            const Text(
              'Ambulance gallery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200, // Chiều cao của các thẻ (card)
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.atEdge) {
                    if (scrollInfo.metrics.pixels != 0) {
                      setState(() {
                        showSeeMore =
                            true; // Hiện nút "see more" khi cuộn đến cuối
                      });
                    }
                  }
                  return true;
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Trượt theo chiều ngang
                  itemCount: 5, // Số lượng phần tử tối đa
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      // Khoảng cách giữa các thẻ
                      child: AmbulanceCard(
                        imagePath: index == 0
                            ? 'assets/ford/1.jpg'
                            : 'assets/mercedes/1.png',
                        title: index == 0
                            ? 'Ford Transit'
                            : 'Mercedes-Benz Sprinter',
                      ),
                    );
                  },
                ),
              ),
            ),

            //TODO: đến đây là hết rồi Huy nhé

            const SizedBox(height: 100),

            // Feedback section
            const Text(
              'Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmbulanceCard extends StatelessWidget {
  final String imagePath;
  final String title;

  AmbulanceCard({required this.imagePath, required this.title});

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
