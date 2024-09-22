import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../models/car.dart';
import '../../services/city_service.dart';

class CarManagerScreen extends StatefulWidget {
  final Account account;

  const CarManagerScreen({super.key, required this.account});

  @override
  State<CarManagerScreen> createState() => _CarManagerScreenState();
}

class _CarManagerScreenState extends State<CarManagerScreen> {
  List<Car> _cars = [];
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      List<Car> cars = await CityService()
          .getCarByDriverPhoneNumber(widget.account.phoneNumber);
      if (cars.isEmpty) {
        if (kDebugMode) {
          print("No cars found for phone: ${widget.account.phoneNumber}");
        }
      } else {
        if (kDebugMode) {
          print("Found cars: $cars");
        }
        setState(() {
          _selectedStatus = cars[0].status;
        });
      }
      setState(() {
        _cars = cars;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching cars: $e");
      }
    } finally {
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Car Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/ford/2.png',
                  height: 150,
                ),
                const SizedBox(height: 16),
                Text(
                  'Car\'s Number: ${_cars.isNotEmpty ? _cars[0].id : 'Does not exist'}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Car\'s Name: ${_cars.isNotEmpty ? _cars[0].name : 'Does not exist'}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusButton(
                    'Driving', Colors.blue, Icons.directions_car),
                const SizedBox(height: 16),
                _buildStatusButton('Busy', Colors.orange, Icons.access_time),
                const SizedBox(height: 16),
                _buildStatusButton(
                    'Completed', Colors.green, Icons.check_circle),
                const SizedBox(height: 16),
                _buildStatusButton(
                    'Waiting', Colors.yellow, Icons.hourglass_empty),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color, IconData icon) {
    bool isSelected = _selectedStatus?.toLowerCase() == status.toLowerCase();

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            CityService().updateCarStatus(widget.account.phoneNumber, status);
            setState(() {
              _selectedStatus = status;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                status,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
