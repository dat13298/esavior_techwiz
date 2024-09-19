import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/hospital.dart';
import '../../services/city_service.dart';
import 'customAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalManager extends StatefulWidget {
  const HospitalManager();

  @override
  _HospitalManagerState createState() => _HospitalManagerState();
}

class _HospitalManagerState extends State<HospitalManager> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hospital Manager',
        subtitle: 'Manage all hospital',
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Hospital',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchTerm = _searchController.text;
                    });
                  },
                ),
              ),
            ),
          ),
          // Nút thêm bệnh viện
          ElevatedButton(
            onPressed: () {
              // Hiện form để thêm bệnh viện
              _showAddHospitalDialog(context);
            },
            child: Text('Add Hospital'),
          ),
          // Hiển thị danh sách bệnh viện
          Expanded(
            child: StreamBuilder<List<Hospital>>(
              stream: CityService().getAllHospital(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final hospitals = snapshot.data!;
                final filteredHospitals = hospitals.where((hospital) {
                  return hospital.name
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredHospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = filteredHospitals[index];
                    return ListTile(
                      title: Text(hospital.name),
                      subtitle: Text(hospital.address),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min, // Để đảm bảo Row không chiếm toàn bộ chiều rộng
                        children: [
                          IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditHospitalDialog(hospital);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                          // Gọi hàm để xóa bệnh viện
                            _confirmDeleteHospital(hospital);
                          },
                        ),
                       ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị form pop-up để thêm bệnh viện
  void _showAddHospitalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Hospital'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Hospital Name'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Hospital Address'),
              ),
              // Thêm các field khác nếu cần
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Xử lý lưu thông tin bệnh viện
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditHospitalDialog(Hospital hospital) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController(text: hospital.name);
        TextEditingController addController = TextEditingController(text: hospital.address);

        return AlertDialog(
          title: Text('Edit Hospital'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Hospital Name'),
              ),
              TextField(
                controller: addController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              // Thêm các field khác nếu cần
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editHospital(hospital.cityID,hospital.id, nameController.text, addController.text,);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

    void _confirmDeleteHospital(Hospital hospital) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${hospital.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteHospital(hospital);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteHospital(Hospital hospital) async {
    await CityService().deleteHospital(hospital.id, hospital.cityID);
    setState(() {
      print('Hospital ${hospital.name} deleted');
    });
  }

  void _editHospital(String cityID,String hospitalId, String newName, String newAddress) {
    // Cập nhật thông tin bệnh viện trong Firestore
    CityService().updateHospital(cityID,hospitalId, newName, newAddress);
    print('Hospital $newName updated');
  }

}
