import 'package:esavior_techwiz/models/car.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/city_service.dart';
import 'custom_app_bar.dart';

class AmbulanceManager extends StatefulWidget {
  const AmbulanceManager({super.key});

  @override
  AmbulanceManagerState createState() => AmbulanceManagerState();
}

class AmbulanceManagerState extends State<AmbulanceManager> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  final CityService _cityService = CityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Ambulance Manager',
        subtitle: 'Manage all ambulance',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Ambulance',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchCars();
                    });
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _showAddAmbulanceDialog(context);
            },
            child: const Text('Add Ambulance'),
          ),
          Expanded(
            child: StreamBuilder<List<Car>>(
              stream: _cityService.getAllCar(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No cars found"));
                }
                final filteredCars = snapshot.data!.where((car) {
                  final nameMatch = car.name
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
                  final phoneMatch = car.driverPhoneNumber
                      .toLowerCase()
                      .contains(_searchTerm.toLowerCase());
                  return nameMatch || phoneMatch;
                }).toList();
                return ListView.builder(
                  itemCount: filteredCars.length,
                  itemBuilder: (context, index) {
                    final car = filteredCars[index];
                    return ListTile(
                      title: Text(car.name),
                      subtitle: Text(car.id),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditCarDialog(car);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDeleteCar(car);
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

  void _showAddAmbulanceDialog(BuildContext context) {
    String? selectedCityId;
    TextEditingController carIDController = TextEditingController();
    TextEditingController carNameController = TextEditingController();
    TextEditingController carDesController = TextEditingController();
    TextEditingController carSeatController = TextEditingController();

    CityService().getCities().then((cities) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Car'),
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
                      controller: carIDController,
                      decoration: const InputDecoration(labelText: 'Car ID'),
                    ),
                    TextField(
                      controller: carNameController,
                      decoration: const InputDecoration(labelText: 'Car Name'),
                    ),
                    TextField(
                      controller: carDesController,
                      decoration:
                          const InputDecoration(labelText: 'Car Description'),
                    ),
                    TextField(
                      controller: carSeatController,
                      decoration:
                          const InputDecoration(labelText: 'Car number seat'),
                    ),
                  ],
                );
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (selectedCityId != null &&
                      carNameController.text.isNotEmpty &&
                      carDesController.text.isNotEmpty &&
                      carSeatController.text.isNotEmpty) {
                    CityService().addCar(
                      selectedCityId!,
                      carIDController.text,
                      carNameController.text,
                      carDesController.text,
                      carSeatController.text,
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

  void _showEditCarDialog(Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController =
            TextEditingController(text: car.name);
        TextEditingController desController =
            TextEditingController(text: car.description);
        return AlertDialog(
          title: const Text('Edit Car'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Car Name'),
              ),
              TextField(
                controller: desController,
                decoration: const InputDecoration(labelText: 'Car Description'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editCar(
                  car.cityID,
                  car.id,
                  nameController.text,
                  desController.text,
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

  void _confirmDeleteCar(Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${car.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteCar(car);
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

  void _deleteCar(Car car) async {
    await CityService().deleteCar(car.id, car.cityID);
    setState(() {
      if (kDebugMode) {
        print('Car ${car.name} deleted');
      }
    });
  }

  void _editCar(
      String cityID, String carID, String newName, String newDescription) {
    CityService().updateCar(cityID, carID, newName, newDescription);
    if (kDebugMode) {
      print('Hospital $newName updated');
    }
  }

  Future<void> _searchCars() async {
    if (_searchTerm.isEmpty) {
      final allCars = await _cityService.getAllCar();
      setState(() {
      });
    } else {
      final nameResults = await _cityService.getCarByName(_searchTerm);
      final phoneResults = await _cityService.getCarByDriverPhone(_searchTerm);
      final Set<String> uniqueIds = {};
      final List<Car> combinedResults = [];
      for (var car in [...nameResults, ...phoneResults]) {
        if (uniqueIds.add(car.id)) {
          combinedResults.add(car);
        }
      }
      setState(() {
      });
    }
  }
}
