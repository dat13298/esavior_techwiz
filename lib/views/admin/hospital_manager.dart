import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/hospital.dart';
import '../../services/city_service.dart';
import 'customAppBar.dart';


class HospitalManager extends StatefulWidget {
  const HospitalManager();

  @override
  _HospitalManagerState createState() => _HospitalManagerState();
}

class _HospitalManagerState extends State<HospitalManager> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  List<Hospital> _hospitals = [];
  String _selectedCity = '';
  List<String> _cities = [];
  final CityService _cityService = CityService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hospital Manager',
        subtitle: 'Manage all hospital',
      ),
      body: Column(
        children: [
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
                      _searchHospitals();
                    });
                  },
                ),
              ),
            ),
          ),
          // Nút thêm bệnh viện
          ElevatedButton(
            onPressed: () {
              //display form to add hospital
              _showAddHospitalDialog(context);
            },
            child: Text('Add Hospital'),
          ),
          //display list hospital
          Expanded(
            child: StreamBuilder<List<Hospital>>(
              stream: _cityService.getAllHospital(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final filteredHospitals = snapshot.data!.where((hospital) {
                  final nameMatch = hospital.name.toLowerCase().contains(_searchTerm.toLowerCase());
                  final addMatch = hospital.address.toLowerCase().contains(_searchTerm.toLowerCase());
                  return nameMatch || addMatch;
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
    String? selectedCityId;
    TextEditingController hospitalNameController = TextEditingController();
    TextEditingController hospitalAddressController = TextEditingController();

    // Gọi CityService để lấy danh sách city
    CityService().getCities().then((cities) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Hospital'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // DropdownButton để chọn city
                    DropdownButton<String>(
                      value: selectedCityId,
                      hint: Text('Select City'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCityId = newValue!;
                        });
                      },
                      items: cities.map((city) {
                        return DropdownMenuItem<String>(
                          value: city['id'],
                          child: Text(city['name']),
                        );
                      }).toList(),
                    ),
                    TextField(
                      controller: hospitalNameController,
                      decoration: InputDecoration(labelText: 'Hospital Name'),
                    ),
                    TextField(
                      controller: hospitalAddressController,
                      decoration: InputDecoration(labelText: 'Hospital Address'),
                    ),
                  ],
                );
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  //check if choose city or not
                  if (selectedCityId != null && hospitalNameController.text.isNotEmpty && hospitalAddressController.text.isNotEmpty) {
                    // add new hospital
                    CityService().addHospital(
                      selectedCityId!,
                      hospitalNameController.text,
                      hospitalAddressController.text,
                    );
                    Navigator.of(context).pop();
                  } else {
                    // display alert if not enough infor
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all the fields')),
                    );
                  }
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
    });
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
    CityService().updateHospital(cityID,hospitalId, newName, newAddress);
    print('Hospital $newName updated');
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchTerm = _searchController.text;
    });
  }

  Future<void> _searchHospitals() async {
    if (_searchTerm.isEmpty) {
      // If search term is empty, load all hospitals
      final allHospitals = await _cityService.getAllHospital();
      setState(() {
        _hospitals = allHospitals as List<Hospital>;
      });
    } else {
      // Perform search
      final nameResults = await _cityService.getHospitalsByName(_searchTerm);
      final locationResults = await _cityService.getHospitalsByLocation(_searchTerm);

      // Combine and remove duplicates
      final Set<String> uniqueIds = {};
      final List<Hospital> combinedResults = [];

      for (var hospital in [...nameResults, ...locationResults]) {
        if (uniqueIds.add(hospital.id)) {
          combinedResults.add(hospital);
        }
      }

      setState(() {
        _hospitals = combinedResults;
      });
    }
  }

}
