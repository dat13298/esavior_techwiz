import 'dart:async';

import 'package:esavior_techwiz/services/address_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
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
  String? startAddress;//address after convert
  String? endAddress;//address after convert
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  //test
  Timer? _positionTimer;

  @override
  void initState() {
    super.initState();
    if (widget.role == 'driver') {
      // _startLocationUpdates();///main method update firebase real time
      _simulateLocationUpdates();///demo

      ///convert
      _convertAddressToDisplay();
    }
    if (widget.role == 'user') {
      // _startLocationUpdates();

      ///convert
      _convertAddressToDisplay();
    }

  }

  //TODO call convert to string address
  Future<void> _convertAddressToDisplay() async{
    setState(() async{
      startAddress = await getAddressFromLatlon(widget.currentPosition); //start
      endAddress = await getAddressFromLatlon(widget.currentPositionDevice); // end
    });
  }

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


///update location driver when move
  Future<void> _startLocationUpdates() async {
    // Kiểm tra quyền truy cập vị trí
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Lấy vị trí liên tục
      _positionStream = Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          _currentPosition = position;
        });
      });
    } else {
      print('Location permission denied');
    }
  }


  ///demo update location driver when move
  void _simulateLocationUpdates() {
    int currentIndex = 0;
    _positionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentIndex < widget.routePoints.length) {
        final currentPoint = widget.routePoints[currentIndex];
        setState(() {
          _currentPosition = Position(
            latitude: currentPoint.latitude,
            longitude: currentPoint.longitude,
            timestamp: DateTime.now(),
            altitude: 0.0,
            accuracy: 5.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );
        });
        currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Distance: ${widget.routeDistance / 1000}km'),
      ),
      body: Stack(
        children: [
          // Bản đồ ở nền
          FlutterMap(
            options: MapOptions(
              // initialCenter: widget.currentPosition,
              initialCenter: widget.role == 'driver'
                  ? _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : widget.currentPosition
                  : widget.currentPosition,
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
                  if (_currentPosition != null)
                    Marker(
                      point: widget.currentPosition,
                      width: 80,
                      height: 80,
                      child: Icon(
                        widget.role == 'user' ? Icons.person : Icons.car_crash_rounded,
                        color: widget.role == 'user' ? Colors.lightBlueAccent : Colors.red,
                      ),
                    ),
                  Marker(
                    point: widget.currentPositionDevice,
                    width: 80,
                    height: 80,
                    child: Icon(
                      widget.role == 'user' ? Icons.car_crash_rounded : Icons.person,
                      color: widget.role == 'user' ? Colors.red : Colors.lightBlueAccent,
                    ),
                  ),
                ],
              )
              ,

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
                      // Địa chỉ điểm bắt đầu
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
                        '$startAddress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 15),

                      // Địa chỉ điểm kết thúc
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
                        '${endAddress}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 20),

                      // Chỉ hiện thị chọn loại xe nếu role là 'user'
                      if (widget.role == 'user') ...[
                        Text(
                          'Select Vehicle Type:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                                      ),
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
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(thickness: 1.5, color: Colors.grey),
                        SizedBox(height: 20),
                      ],

                      // Chỉ hiện thị chọn ngày giờ nếu role là 'user'
                      if (widget.role == 'user') ...[
                        Text(
                          'Select Date & Time:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                      ],

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
                              child: Text('Cancel', style: TextStyle(color: Colors.white)),
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
                              child: Text('Confirm', style: TextStyle(color: Colors.white)),
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
