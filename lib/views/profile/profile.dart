import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/views/home/homepage.dart';
import 'package:flutter/material.dart';

import '../welcome/welcome_page.dart';

class eSaviorProfile extends StatefulWidget {
  final Account account;

  const eSaviorProfile({super.key, required this.account});

  @override
  _eSaviorProfileState createState() => _eSaviorProfileState();
}

class _eSaviorProfileState extends State<eSaviorProfile> {
  Future<void> _logout() async {
    try {
      // await FirebaseAuth.instance.signOut();  dang ko co thu vien FirebaseAuth
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              // User Name
              Text(
                widget.account.fullName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              // User Email
              Text(
                'Phone Number: ${widget.account.phoneNumber}',
                // Hiển thị số điện thoại
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              // User Phone
              Text(
                'Email: ${widget.account.email}', // Hiển thị email
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              // User Phone
              Text(
                'Address: ${widget.account.addressHome}', // Hiển thị email
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Edit Profile Button
              _buildProfileOption(
                icon: Icons.edit,
                text: 'Edit profile',
                onTap: () {
                  // Handle Edit profile action
                },
              ),
              const SizedBox(height: 10),

              // Change Password Button
              _buildProfileOption(
                icon: Icons.lock,
                text: 'Change password',
                onTap: () {
                  // Handle Change password action
                },
              ),
              const SizedBox(height: 10),

              // About this app Button
              _buildProfileOption(
                icon: Icons.info_outline,
                text: 'About this app',
                onTap: () {
                  // Handle About this app action
                },
              ),
              const Spacer(),

              // Log Out Button

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10CCC6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  // Xử lý đăng xuất
                  await _logout(); // Thực hiện thao tác đăng xuất, nếu cần

                  // Chuyển hướng sang WelcomePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                },
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => eSaviorHome(account: widget.account)),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Activities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  // Reusable widget for profile options
  Widget _buildProfileOption(
      {required IconData icon, required String text, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
