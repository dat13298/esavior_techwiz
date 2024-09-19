import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // MaterialApp added here
      title: 'eSavior',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: AppBar(
              backgroundColor: Color(0xFF10CCC6),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'eSavior',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'About this app',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'We are NextGen Creators!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We are a passionate team of young innovators driven by a common goal: to make a positive impact in our communities. With a strong belief in using technology to solve real-world problems, we’ve developed eSavior, an ambulance booking app designed to save time and lives in critical moments.\n "
                      "Our journey began with the desire to create an efficient, reliable, and user-friendly solution for those in need of emergency medical services. By combining our expertise in technology and our dedication to helping others, we aim to revolutionize the way people access ambulance services, ensuring quick and seamless support when it matters most.\n"
                      "At NextGen Creators, we believe in the power of youth, innovation, and compassion to drive meaningful change. Our mission is simple: to empower individuals with the tools they need to get help, fast. We are committed to continuous improvement and look forward to shaping a safer, more connected future with eSavior.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Team members',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 100,
                  runSpacing: 30,
                  children: [
                    buildTeamMember('Huy Pham Dinh', 'assets/huy_pham.png'),
                    buildTeamMember('Thanh Nguyen Ngoc', 'assets/thanh_nguyen.png'),
                    buildTeamMember('Hung Ha Quang', 'assets/ha_hung.png'),
                    buildTeamMember('Dat Nguyen', 'assets/dat_nguyen.png'),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
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
    );
  }

  // Helper function to build team member widget with square image
  Widget buildTeamMember(String name, String imagePath) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),  // Add some rounding for smoother edges if desired
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
