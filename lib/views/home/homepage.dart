import 'package:esavior_techwiz/views/profile/profile.dart';
import 'package:flutter/material.dart';
 // Import the ProfilePage to navigate to it

class eSaviorHome extends StatelessWidget {
  const eSaviorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0), // Set the height of the AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), // Rounded corners at bottom-left
            bottomRight: Radius.circular(30), // Rounded corners at bottom-right
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Search bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search places',
                  prefixIcon: Icon(Icons.search),
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
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Square corners
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

              // Ambulance gallery
              const Text(
                'Ambulance gallery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AmbulanceCard(
                      imagePath: 'assets/ford_transit.png',
                      title: 'Ford Transit',
                    ),
                    const SizedBox(width: 5),
                    AmbulanceCard(
                      imagePath: 'assets/mercedes_sprinter.png',
                      title: 'Mercedes-Benz Sprinter',
                    ),
                    const SizedBox(width: 10),
                    // Icon and "see more" button
                    Column(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: const Icon(Icons.arrow_forward)
                        ),// The ">" icon
                        TextButton(
                          onPressed: () {
                            // See more action
                          },
                          child: Text('see more',style: TextStyle(color: Colors.black),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),

              // Feedback section
              Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // You can add your feedback form or details here
            ],
          ),
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => eSaviorProfile()), // Navigate to ProfilePage
            );
          }
        },
        items: [
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
        SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}
