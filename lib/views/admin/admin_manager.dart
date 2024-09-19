import 'package:esavior_techwiz/views/admin/driver_manager.dart';
import 'package:flutter/material.dart';
import 'customAppBar.dart';
import 'hospital_manager.dart';

class ManagerTab extends StatelessWidget {
  const ManagerTab();

  @override
  Widget build(BuildContext context) {
    // Danh sách các mục quản lý
    final List<Map<String, dynamic>> managementItems = [
      {'icon': Icons.drive_eta, 'title': 'Driver Manager', 'color': Color(0xFF10CCC6)},
      {'icon': Icons.local_hospital, 'title': 'Hospital Manager', 'color': Color(0xFF10CCC6)},
      {'icon': Icons.emergency, 'title': 'Booking Manager', 'color': Color(0xFF10CCC6)},
      {'icon': Icons.person, 'title': 'Car Manager', 'color': Color(0xFF10CCC6)},
      // {'icon': Icons.settings, 'title': 'Settings', 'color': Color(0xFF10CCC6)},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dispatcher Manager',
        subtitle: 'Manage everything here.',
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: managementItems.length,
        itemBuilder: (context, index) {
          final item = managementItems[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item['color'],
                child: Icon(item['icon'], color: Colors.white),
              ),
              title: Text(
                item['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF10CCC6)),
              onTap: () {
                  if (item['title'] == 'Hospital Manager') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HospitalManager()),
                    );
                  }
                  if (item['title'] == 'Driver Manager') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverManager()),
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