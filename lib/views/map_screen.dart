import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng currentPositionDevice;
  final LatLng currentPosition;
  final String role;
  final double routeDistance;
  final List<LatLng> routePoints;

  const MapScreen({
    Key? key,
    required this.currentPositionDevice,
    required this.currentPosition,
    required this.role,
    required this.routeDistance,
    required this.routePoints,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedVehicle = 'emergency'; // Giá trị mặc định

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng end = LatLng(21.035000, 105.825649); // Điểm kết thúc

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map: ${widget.routeDistance}'),
      ),
      body: Stack(
        children: [
          // Bản đồ ở nền
          FlutterMap(
            options: MapOptions(
              initialCenter: widget.currentPosition,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.routePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: widget.currentPosition,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.person, color: Colors.red),
                  ),
                  Marker(
                    point: end,
                    width: 80,
                    height: 80,
                    child: Icon(Icons.car_crash_rounded, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),

          // Ô cuộn nội dung ở chân trang
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.71,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Địa chỉ điểm bắt đầu (Label và Value)
                      Text(
                        'Start Location:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${widget.currentPosition.latitude}, ${widget.currentPosition.longitude}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      // Line phân tách
                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 15),

                      // Địa chỉ điểm kết thúc (Label và Value)
                      Text(
                        'End Location:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${end.latitude}, ${end.longitude}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      // Line phân tách
                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 20),

                      // Chọn loại xe với border đổi màu
                      Text(
                        'Select Vehicle Type:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Custom Vehicle Type Selector
                      Column(
                        children: [
                          // Hàng 1
                          Row(
                            children: [

                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedVehicle = 'emergency';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedVehicle == 'emergency' ? Colors.green : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.local_hospital, color: Colors.red),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Emergency Vehicle',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            Text('10,000 VND'),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Hàng 2
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedVehicle = 'non_emergency';
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedVehicle == 'non_emergency' ? Colors.green : Colors.grey,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.local_hospital, color: Colors.blue),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Non-Emergency Vehicle',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            Text('5,000 VND'),
                                          ],
                                        ),
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Line phân tách
                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 20),

                      // Chọn ngày và giờ
                      Text(
                        'Select Date & Time:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickDate(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  selectedDate != null
                                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                      : 'Pick Date',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickTime(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  selectedTime != null
                                      ? "${selectedTime!.hour}:${selectedTime!.minute}"
                                      : 'Pick Time',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Nút Confirm và Cancel
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Màu nền của nút Cancel
                              ),
                              onPressed: () {
                                // Xử lý nút Cancel
                              },
                              child: Text('Cancel', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Màu nền của nút Confirm
                              ),
                              onPressed: () {
                                // Xử lý nút Confirm
                              },
                              child: Text('Confirm', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
