import 'package:esavior_techwiz/views/admin/ambulance_manager.dart';
import 'package:esavior_techwiz/views/admin/booking_manager.dart';
import 'package:esavior_techwiz/views/admin/driver_manager.dart';
import 'package:flutter/material.dart';
import 'custom_app_bar.dart';
import 'hospital_manager.dart';

class ManagerTab extends StatefulWidget {
  const ManagerTab({super.key});

  @override
  _ManagerTabState createState() => _ManagerTabState();
}

class _ManagerTabState extends State<ManagerTab> {
  final List<Map<String, dynamic>> managementItems = [
    {
      'icon': Icons.person,
      'title': 'Driver Manager',
      'color': const Color(0xFF10CCC6)
    },
    {
      'icon': Icons.local_hospital,
      'title': 'Hospital Manager',
      'color': const Color(0xFF10CCC6)
    },
    {
      'icon': Icons.local_taxi,
      'title': 'Booking Manager',
      'color': const Color(0xFF10CCC6)
    },
    {
      'icon': Icons.drive_eta,
      'title': 'Ambulance Manager',
      'color': const Color(0xFF10CCC6)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Dispatcher Manager',
        subtitle: 'Manage everything here.',
        showBackButton: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: managementItems.length,
        itemBuilder: (context, index) {
          final item = managementItems[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['color'],
                child: Icon(item['icon'], color: Colors.white),
              ),
              title: Text(
                item['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing:
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF10CCC6)),
              onTap: () {
                if (item['title'] == 'Hospital Manager') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HospitalManager()),
                  );
                }
                if (item['title'] == 'Driver Manager') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DriverManager()),
                  );
                }
                if (item['title'] == 'Ambulance Manager') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AmbulanceManager()),
                  );
                }
                if (item['title'] == 'Booking Manager') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingManager()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
