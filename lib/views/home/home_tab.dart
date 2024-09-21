// import 'package:esavior_techwiz/models/account.dart';
// import 'package:esavior_techwiz/views/driver/driver_home.dart';
// import 'package:esavior_techwiz/views/profile/profile.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class HomeTab extends StatefulWidget {
//   final Account account;
//   const HomeTab({super.key, required this.account});
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomeTab> {
//   int _selectedIndex = 0;
//   bool showSeeMore = false; // Biến để kiểm soát việc hiển thị nút "see more"
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     if (index == 3) {
//       // Điều hướng tới trang profile
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => eSaviorProfile(account: widget.account)),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(110.0),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(30),
//             bottomRight: Radius.circular(30),
//           ),
//           child: AppBar(
//             backgroundColor: const Color(0xFF10CCC6),
//             title: const Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'eSavior',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 30,
//                   ),
//                 ),
//                 Text(
//                   'Your health is our care!',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 30),
//             // Search bar
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search places',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Emergency button
//             Center(
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 onPressed: () {
//                   // Emergency button action
//                 },
//                 child: const Text(
//                   'Call emergency',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Ambulance gallery
//             const Text(
//               'Ambulance gallery',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 200, // Chiều cao của các thẻ (card)
//               child: NotificationListener<ScrollNotification>(
//                 onNotification: (ScrollNotification scrollInfo) {
//                   if (scrollInfo.metrics.atEdge) {
//                     if (scrollInfo.metrics.pixels != 0) {
//                       setState(() {
//                         showSeeMore = true; // Hiện nút "see more" khi cuộn đến cuối
//                       });
//                     }
//                   }
//                   return true;
//                 },
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal, // Trượt theo chiều ngang
//                   itemCount: 5, // Số lượng phần tử tối đa
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 5.0), // Khoảng cách giữa các thẻ
//                       child: AmbulanceCard(
//                         imagePath: index == 0
//                             ? 'assets/ford/1.jpg'
//                             : 'assets/mercedes/1.png',
//                         title: index == 0 ? 'Ford Transit' : 'Mercedes-Benz Sprinter',
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 100),
//
//             // Feedback section
//             const Text(
//               'Feedback',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       // Bottom navigation bar
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.access_time),
//             label: 'Activities',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Notifications',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AmbulanceCard extends StatelessWidget {
//   final String imagePath;
//   final String title;
//
//   AmbulanceCard({required this.imagePath, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 120,
//           height: 100,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(title),
//       ],
//     );
//   }
// }
