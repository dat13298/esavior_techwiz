  import 'package:esavior_techwiz/models/account.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  
  import '../welcome/welcome_page.dart';
  import 'customAppBar.dart';
  
  class ProfileTab extends StatefulWidget {
    final Account account;
    const ProfileTab({super.key, required this.account});
  
    @override
    State<ProfileTab> createState() => _ProfileTabState();
  }
  
  class _ProfileTabState extends State<ProfileTab> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Profile',
          subtitle: 'Profile page',
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
      );
    }
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
  
