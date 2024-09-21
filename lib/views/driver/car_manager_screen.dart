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
  String? _selectedStatus; // Lưu trữ trạng thái được chọn
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      List<Car> cars = await CityService().getCarByDriverPhoneNumber(widget.account.phoneNumber);
      if (cars.isEmpty) {
        print("No cars found for phone: ${widget.account.phoneNumber}");
      } else {
        print("Found cars: $cars");
        // Lấy status của xe đầu tiên và đặt làm selected status
        setState(() {
          _selectedStatus = cars[0].status; // Cập nhật trạng thái xe
        });
      }
      setState(() {
        _cars = cars;
      });
    } catch (e) {
      print("Error fetching cars: $e");
    } finally {
      setState(() {
        _isLoading = false;
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
          // Hình ảnh hoặc biểu tượng xe
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/ford/2.png', // Đường dẫn đến hình ảnh
                  height: 150,
                ),
                const SizedBox(height: 16),
                Text(
                  'Car\'s Number: ${_cars.isNotEmpty ? _cars[0].id : 'Does not exist'}', // Hiển thị biển số xe đầu tiên
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Car\'s Name: ${_cars.isNotEmpty ? _cars[0].name : 'Does not exist'}', // Hiển thị tên xe đầu tiên
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Các nút trạng thái theo chiều dọc
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusButton('Driving', Colors.blue, Icons.directions_car),
                const SizedBox(height: 16),
                _buildStatusButton('Busy', Colors.orange, Icons.access_time),
                const SizedBox(height: 16),
                _buildStatusButton('Completed', Colors.green, Icons.check_circle),
                const SizedBox(height: 16),
                _buildStatusButton('Waiting', Colors.yellow, Icons.hourglass_empty),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(String status, Color color, IconData icon) {
    bool isSelected = _selectedStatus?.toLowerCase() == status.toLowerCase(); // So sánh trạng thái hiện tại với trạng thái của xe

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9, // Đảm bảo các nút có cùng kích thước
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? color : Colors.grey, // Thay đổi màu nếu được chọn
            padding: const EdgeInsets.symmetric(vertical: 15), // Điều chỉnh độ dày của nút
          ),
          onPressed: () {
            CityService().updateCarStatus(widget.account.phoneNumber, status);
            setState(() {
              _selectedStatus = status; // Cập nhật trạng thái khi nhấn nút
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung trong nút
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

  // Hàm cập nhật trạng thái xe
  // Future<void> _updateCarStatus(String newStatus) async {
  //   if (_cars.isNotEmpty) {
  //     try {
  //       Car carToUpdate = _cars[0]; // Lấy xe đầu tiên (hoặc tùy chỉnh theo ý muốn)
  //       carToUpdate.status = newStatus; // Cập nhật trạng thái mới
  //
  //       // Gọi hàm cập nhật trong CityService (hoặc service tương ứng)
  //       await CityService().updateCarStatus(carToUpdate);
  //
  //       print("Car status updated to $newStatus");
  //     } catch (e) {
  //       print("Error updating car status: $e");
  //     }
  //   }
  // }
}
