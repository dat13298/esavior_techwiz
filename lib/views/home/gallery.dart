import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambulance Gallery'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Ford',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList(
                  'assets/ford/1.jpg', 'Ford Transit Ambulance', '5.8m', [
                'Defibrillator',
                'Stretcher',
                'Oxygen cylinder',
                'Ventilator',
                'First aid kit',
                'Cardiac monitor',
              ], 'assets/ford/2.png', 'Ford E-Series Ambulance', '6.2m', [
                'Suction machine',
                'Stretcher',
                'Portable ECG',
                'IV infusion kit',
                'Patient monitoring system',
                'Advanced life support tools',
              ], screenWidth),
              _buildCarList(
                  'assets/ford/3.jpg', 'Ford Transit Ambulance', '5.8m', [
                'Defibrillator',
                'Stretcher',
                'Oxygen cylinder',
                'Ventilator',
                'First aid kit',
                'Cardiac monitor',
              ], 'assets/ford/4.jpg', 'Ford E-Series Ambulance', '6.2m', [
                'Suction machine',
                'Stretcher',
                'Portable ECG',
                'IV infusion kit',
                'Patient monitoring system',
                'Advanced life support tools',
              ], screenWidth),
              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Mercedes-Benz',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList('assets/mercedes/1.png', 'Mercedes-Benz Sprinter', '6.0m', [
                'Defibrillator',
                'Stretcher',
                'Oxygen cylinder',
                'Patient monitoring system',
                'Spinal immobilization board',
                'Ventilator',
              ], 'assets/mercedes/2.jpg', 'Mercedes-Benz Vito Ambulance', '5.5m', [
                'First aid kit',
                'IV fluids',
                'Suction machine',
                'Portable ECG',
                'Patient transport system',
              ], screenWidth),
              _buildCarList('assets/mercedes/3.jpg', 'Mercedes-Benz Sprinter', '6.0m', [
                'Defibrillator',
                'Stretcher',
                'Oxygen cylinder',
                'Patient monitoring system',
                'Spinal immobilization board',
                'Ventilator',
              ], 'assets/mercedes/4.png', 'Mercedes-Benz Vito Ambulance', '5.5m', [
                'First aid kit',
                'IV fluids',
                'Suction machine',
                'Portable ECG',
                'Patient transport system',
              ], screenWidth),
              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Hyundai',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList('assets/hyundai/1.jpg', 'Hyundai Starex Ambulance', '5.1m', [
                'Basic life support equipment',
                'Oxygen cylinder',
                'Stretcher',
                'IV fluids',
                'Suction machine',
              ], 'assets/hyundai/2.jpg', 'Hyundai iLoad Ambulance', '5.4m', [
                'First aid kit',
                'Patient monitoring system',
                'Defibrillator',
                'Ventilator',
                'Stretcher',
              ], screenWidth),
              const Padding(
                padding: EdgeInsets.only(top: 32.0, bottom: 16.0),
                child: Text(
                  'Nissan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList('assets/nissan/1.jpg', 'Nissan NV350 Ambulance', '5.3m', [
                'Defibrillator',
                'Stretcher',
                'Portable ECG',
                'Oxygen cylinder',
                'Suction machine',
              ], 'assets/nissan/2.jpg', 'Nissan Patrol Ambulance', '5.9m', [
                'Spinal immobilization board',
                'Ventilator',
                'Stretcher',
                'Patient transport system',
                'Advanced life support tools',
              ], screenWidth),



              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Toyota',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList(
                  'assets/toyota/1.jpg', 'Toyota Hiace Ambulance', '5.7m', [
                'Ventilator',
                'Defibrillator',
                'Trauma kit',
                'IV fluids',
                'Oxygen mask',
                'Stretcher',
              ], 'assets/toyota/2.jpg', 'Toyota Land Cruiser Ambulance', '6.0m', [
                'Suction unit',
                'Cardiac monitor',
                'Stretcher',
                'Portable ventilator',
                'Patient monitoring system',
                'Advanced trauma care kit',
              ], screenWidth),
              _buildCarList(
                  'assets/toyota/3.png', 'Toyota Hilux Ambulance', '5.5m', [
                'Oxygen cylinder',
                'Emergency resuscitation kit',
                'Surgical instruments',
                'Stretcher',
                'IV pump',
                'Portable ultrasound',
              ], 'assets/toyota/4.jpg', 'Toyota Fortuner Ambulance', '6.1m', [
                'Advanced oxygen delivery system',
                'Patient transport stretcher',
                'Blood pressure monitor',
                'Suction machine',
                'First aid kit',
                'Infusion pumps',
              ], screenWidth),

              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Range Rover',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList(
                  'assets/landrover/1.jpg', 'Range Rover Defender Ambulance', '5.9m', [
                'Ventilator',
                'Cardiac monitor',
                'Oxygen supply system',
                'Defibrillator',
                'Trauma care kit',
                'Mobile ECG',
              ], 'assets/landrover/2.jpg', 'Range Rover Evoque Ambulance', '6.3m', [
                'Patient warming system',
                'Portable X-ray machine',
                'First aid kit',
                'Stretcher',
                'Suction machine',
                'Advanced emergency tools',
              ], screenWidth),
              _buildCarList(
                  'assets/landrover/3.jpg', 'Range Rover Discovery Ambulance', '5.6m', [
                'Advanced ventilator',
                'Oxygen cylinder',
                'First aid kit',
                'Defibrillator',
                'Spinal board',
                'Emergency lighting system',
              ], 'assets/landrover/4.jpg', 'Range Rover Velar Ambulance', '6.0m', [
                'Portable ventilator',
                'Surgical instruments',
                'Stretcher',
                'Suction unit',
                'Defibrillator',
                'Monitoring system',
              ], screenWidth),

              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Volkswagen',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCarList(
                  'assets/vokswa/1.jpg', 'Volkswagen Transporter Ambulance', '6.0m', [
                'Advanced life support tools',
                'Defibrillator',
                'Trauma kit',
                'Oxygen supply system',
                'Stretcher',
                'IV fluids',
              ], 'assets/vokswa/2.jpg', 'Volkswagen Crafter Ambulance', '5.9m', [
                'Suction machine',
                'Ventilator',
                'First aid kit',
                'Spinal board',
                'Patient monitoring system',
                'Portable ECG',
              ], screenWidth),
              _buildCarList(
                  'assets/vokswa/3.jpg', 'Volkswagen Amarok Ambulance', '5.8m', [
                'Oxygen cylinder',
                'Advanced trauma kit',
                'Defibrillator',
                'Stretcher',
                'Ventilator',
                'Cardiac monitor',
              ], 'assets/vokswa/4.jpg', 'Volkswagen Caravelle Ambulance', '6.1m', [
                'Emergency response tools',
                'Portable ventilator',
                'IV infusion kit',
                'Suction unit',
                'Stretcher',
                'Patient warming system',
              ], screenWidth),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarList(
      String imagePath1,
      String carName1,
      String carSize1,
      List<String> equipmentList1,
      String imagePath2,
      String carName2,
      String carSize2,
      List<String> equipmentList2,
      double screenWidth,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCarItem(imagePath1, carName1, carSize1, equipmentList1, screenWidth),
        _buildCarItem(imagePath2, carName2, carSize2, equipmentList2, screenWidth),
      ],
    );
  }

  Widget _buildCarItem(
      String imagePath,
      String carName,
      String carSize,
      List<String> equipmentList,
      double screenWidth,
      ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              carName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Size: $carSize',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'Equipment:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            for (String equipment in equipmentList)
              Text(
                '- $equipment',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
