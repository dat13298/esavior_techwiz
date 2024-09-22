import 'package:esavior_techwiz/models/account.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final Account account;

  const Notifications({super.key, required this.account});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eSavior',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
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
                  Text(
                    'eSavior',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    'About this app',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
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
                  "We are a passionate team of young innovators driven by a common goal: to make a positive impact in our communities. With a strong belief in using technology to solve real-world problems, we’ve developed eSavior, an ambulance booking app designed to save time and lives in critical moments.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Our journey began with the desire to create an efficient, reliable, and user-friendly solution for those in need of emergency medical services. By combining our expertise in technology and our dedication to helping others, we aim to revolutionize the way people access ambulance services, ensuring quick and seamless support when it matters most.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  "At NextGen Creators, we believe in the power of youth, innovation, and compassion to drive meaningful change. Our mission is simple: to empower individuals with the tools they need to get help, fast. We are committed to continuous improvement and look forward to shaping a safer, more connected future with eSavior.",
                  textAlign: TextAlign.justify,
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
                const SizedBox(height: 20),
                Column(
                  children: [
                    Center(
                      child: buildTeamMember(
                          'Dat Nguyen - Leader', 'assets/dat_nguyen.png'),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTeamMember(
                            'Thanh Nguyen Ngoc', 'assets/thanh_nguyen.png'),
                        const SizedBox(width: 50),
                        buildTeamMember('Hung Ha Quang', 'assets/ha_hung.png'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: buildTeamMember(
                          'Huy Pham Dinh', 'assets/huy_pham.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

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
            borderRadius: BorderRadius.circular(10),
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
