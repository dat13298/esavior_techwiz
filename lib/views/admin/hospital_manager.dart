import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/hospital.dart';
import '../../services/city_service.dart';
import 'custom_app_bar.dart';

class HospitalManager extends StatefulWidget {
  const HospitalManager({super.key});

  @override
  _HospitalManagerState createState() => _HospitalManagerState();
}

class _HospitalManagerState extends State<HospitalManager> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  List<Hospital> _hospitals = [];
  final List<String> _cities = [];
  final CityService _cityService = CityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
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
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchHospitals();
                    });
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddHospitalDialog(context);
            },
            child: const Text('Add Hospital'),
          ),
          Expanded(
            child: StreamBuilder<List<Hospital>>(
              stream: _cityService.getAllHospital(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredHospitals = snapshot.data!.where((hospital) {
                  final nameMatch = hospital.name
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
                  final addMatch = hospital.address
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditHospitalDialog(hospital);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
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

  void _showAddHospitalDialog(BuildContext context) {
    String? selectedCityId;
    TextEditingController hospitalNameController = TextEditingController();
    TextEditingController hospitalAddressController = TextEditingController();

    CityService().getCities().then((cities) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Hospital'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: selectedCityId,
                      hint: const Text('Select City'),
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
                      decoration:
                          const InputDecoration(labelText: 'Hospital Name'),
                    ),
                    TextField(
                      controller: hospitalAddressController,
                      decoration:
                          const InputDecoration(labelText: 'Hospital Address'),
                    ),
                  ],
                );
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (selectedCityId != null &&
                      hospitalNameController.text.isNotEmpty &&
                      hospitalAddressController.text.isNotEmpty) {
                    CityService().addHospital(
                      selectedCityId!,
                      hospitalNameController.text,
                      hospitalAddressController.text,
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill all the fields')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
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
        TextEditingController nameController =
            TextEditingController(text: hospital.name);
        TextEditingController addController =
            TextEditingController(text: hospital.address);

        return AlertDialog(
          title: const Text('Edit Hospital'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Hospital Name'),
              ),
              TextField(
                controller: addController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editHospital(
                  hospital.cityID,
                  hospital.id,
                  nameController.text,
                  addController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${hospital.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteHospital(hospital);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Yes'),
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

  void _editHospital(
      String cityID, String hospitalId, String newName, String newAddress) {
    CityService().updateHospital(cityID, hospitalId, newName, newAddress);
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
      final allHospitals = await _cityService.getAllHospital();
      setState(() {
        _hospitals = allHospitals as List<Hospital>;
      });
    } else {
      final nameResults = await _cityService.getHospitalsByName(_searchTerm);
      final locationResults =
          await _cityService.getHospitalsByLocation(_searchTerm);

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
