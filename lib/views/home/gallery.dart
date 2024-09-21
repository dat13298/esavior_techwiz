import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy chiều rộng màn hình
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Thêm padding cho toàn bộ khung sườn
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Toyota',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Toyota
              _buildCarList('assets/ford/1.jpg', 'Toyota Camry', 'assets/ford/2.png', 'Toyota Corolla', screenWidth),
              _buildCarList('assets/ford/3.jpg', 'Toyota RAV4', 'assets/ford/4.jpg', 'Toyota Yaris', screenWidth),

              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Mercedes-Benz',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Mercedes-Benz
              _buildCarList('assets/mercedes/1.png', 'Mercedes-Benz C-Class', 'assets/mercedes/2.jpg', 'Mercedes-Benz E-Class', screenWidth),
              _buildCarList('assets/mercedes/3.jpg', 'Mercedes-Benz GLE', 'assets/mercedes/4.png', 'Mercedes-Benz S-Class', screenWidth),

              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Hyundai',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Hyundai
              _buildCarList('assets/hyundai/1.jpg', 'Hyundai Elantra', 'assets/hyundai/2.jpg', 'Hyundai Sonata', screenWidth),

              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Land Rover',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Land Rover
              _buildCarList('assets/landrover/1.jpg', 'Land Rover Defender', 'assets/landrover/2.jpg', 'Land Rover Discovery', screenWidth),
              _buildCarList('assets/landrover/3.jpg', 'Land Rover Range Rover', 'assets/landrover/4.jpg', 'Land Rover Evoque', screenWidth),

              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Nissan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Nissan
              _buildCarList('assets/nissan/1.jpg', 'Nissan Altima', 'assets/nissan/2.jpg', 'Nissan Maxima', screenWidth),

              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Ford',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Ford
              _buildCarList('assets/ford/1.jpg', 'Ford F-150', 'assets/ford/2.png', 'Ford Mustang', screenWidth),
              _buildCarList('assets/ford/3.jpg', 'Ford Explorer', 'assets/ford/4.jpg', 'Ford Escape', screenWidth),

              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Volkswagen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              // Hàng hình ảnh Volkswagen
              _buildCarList('assets/vokswa/1.jpg', 'Volkswagen Golf', 'assets/vokswa/2.jpg', 'Volkswagen Jetta', screenWidth),
              _buildCarList('assets/vokswa/3.jpg', 'Volkswagen Tiguan', 'assets/vokswa/4.jpg', 'Volkswagen Passat', screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarList(String imagePath1, String carName1, String imagePath2, String carName2, double screenWidth) {
    return Container(
      height: (screenWidth * 0.5 - 32) + 60, // Chiều cao tăng để đủ cho ảnh và tên xe
      child: ListView(
        scrollDirection: Axis.horizontal, // Cuộn ngang
        children: [
          _buildCarItem(imagePath1, carName1, screenWidth),
          _buildCarItem(imagePath2, carName2, screenWidth),
        ],
      ),
    );
  }

  Widget _buildCarItem(String imagePath, String carName, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Bo góc tròn 20px
            child: Image.asset(
              imagePath,
              width: screenWidth * 0.5 - 32, // Chiều rộng bằng 50% chiều rộng màn hình
              height: screenWidth * 0.5 - 32, // Chiều cao bằng chiều rộng để tạo hình vuông
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16), // Khoảng cách lớn hơn giữa ảnh và tên
          Text(carName, style: const TextStyle(fontSize: 16)), // Tên xe
        ],
      ),
    );
  }
}
