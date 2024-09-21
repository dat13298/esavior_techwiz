import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:esavior_techwiz/services/address_service.dart';
import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final LatLng endPosition;///end
  final LatLng startPosition;///start
  final double routeDistance;
  final List<LatLng> routePoints;
  final bool isOnBookingShow;
  final Account currentAccount;

  const MapScreen({
    super.key,
    required this.endPosition,
    required this.startPosition,
    required this.routeDistance,
    required this.routePoints,
    required this.isOnBookingShow,
    required this.currentAccount,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String selectedVehicle = 'emergency';

  double amountEmergency = 10000;
  double amountNonEmergency = 7000;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? startAddress;//address after convert
  String? endAddress;//address after convert
  Position? _startPosition;
  StreamSubscription<Position>? _positionStream;

  Timer? _positionTimer;

  @override
  void initState() {
    super.initState();
    if (widget.currentAccount.role == 'driver') {
      // _startLocationUpdates();///main method update firebase real time
      _simulateLocationUpdates();///demo

      ///convert
      _convertAddressToDisplay();
    }
    if (widget.currentAccount.role == 'user') {
      // _startLocationUpdates();

      ///convert
      _convertAddressToDisplay();
    }

  }

  //convert to string address
  Future<void> _convertAddressToDisplay() async{
    String startAddr = await getAddressFromLatlon(widget.startPosition); //start
    String endAddr = await getAddressFromLatlon(widget.endPosition); // end

    if (mounted) {
      setState(() {
        startAddress = startAddr;
        endAddress = endAddr;
      });
    }
  }
  
  //add booking when confirm
  Future<void> _addBooking(Account user) async{
    DateTime bookingDateTime = _combineDateAndTime(selectedDate!, selectedTime!);
    Timestamp bookingTimestamp = Timestamp.fromDate(bookingDateTime);
    double totalAmount = 0;
    if(selectedVehicle == 'emergency'){
      totalAmount = amountEmergency * widget.routeDistance;
    }
    if(selectedVehicle == 'non_emergency'){
      totalAmount = amountNonEmergency * widget.routeDistance;
    }
    Booking newBooking = Booking(
      id: null,
      carID: 'abc',
      startLongitude: widget.startPosition.longitude,
      startLatitude: widget.startPosition.latitude,
      endLongitude: widget.endPosition.longitude,
      endLatitude: widget.endPosition.latitude,
      userPhoneNumber: widget.currentAccount.phoneNumber,
      dateTime: bookingTimestamp,
      type: selectedVehicle,
      cost: totalAmount,
      status: 'waiting',
      driverPhoneNumber: '3123123',
    );

    await BookingService().addBooking(newBooking);
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

// Hàm convert DateTime và TimeOfDay thành một DateTime duy nhất
  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }



///update location driver when move
  Future<void> _startLocationUpdates() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _positionStream = Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          _startPosition = position;
        });
      });
    } else {
      if (kDebugMode) {
        print('Location permission denied');
      }
    }
  }


  ///demo update location driver when move
  void _simulateLocationUpdates() {
    int currentIndex = 0;
    _positionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentIndex < widget.routePoints.length) {
        final currentPoint = widget.routePoints[currentIndex];
        setState(() {
          _startPosition = Position(
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

  IconData getIconForRole(String role, bool isStart) {
    switch (role) {
      case 'user':
        if (widget.isOnBookingShow){
          return Icons.local_hospital;
        }
        return Icons.person;
      case 'driver':
        return isStart ? Icons.car_crash_rounded : Icons.person;
    // Thêm các trường hợp khác nếu cần
      default:
        return Icons.help; // Icon mặc định
    }
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
              // initialCenter: widget.startPosition,
              initialCenter: widget.currentAccount.role == 'driver'
                  ? _startPosition != null
                  ? LatLng(_startPosition!.latitude, _startPosition!.longitude)
                  : widget.startPosition
                  : widget.startPosition,
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
                  if (_startPosition != null)
                    Marker(
                      point: widget.startPosition,///start
                      width: 80,
                      height: 80,
                      child: Icon(
                        getIconForRole(widget.currentAccount.role, true),
                        color: widget.currentAccount.role == 'user' ? Colors.lightBlueAccent : Colors.red,
                      ),
                    ),
                  Marker(
                    point: widget.endPosition,///end
                    width: 80,
                    height: 80,
                    child: Icon(
                      getIconForRole(widget.currentAccount.role, false),
                      color: widget.currentAccount.role == 'user' ? Colors.red : Colors.lightBlueAccent,
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
                decoration: const BoxDecoration(
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
                      const Text(
                        'Start Location:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$startAddress',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 15),

                      // Địa chỉ điểm kết thúc
                      const Text(
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(thickness: 1.5, color: Colors.grey),
                      SizedBox(height: 20),

                      // Chỉ hiện thị chọn loại xe nếu role là 'user'
                      if (widget.currentAccount.role == 'user') ...[
                        const Text(
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
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedVehicle = 'emergency';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedVehicle == 'emergency' ? Colors.green : Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.local_hospital, color: Colors.red),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Emergency Vehicle',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              Text('${amountEmergency * widget.routeDistance} VND'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Hàng 2
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedVehicle = 'non_emergency';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: selectedVehicle == 'non_emergency' ? Colors.green : Colors.grey,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.local_hospital, color: Colors.blue),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Non-Emergency Vehicle',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                              Text('${amountNonEmergency * widget.routeDistance} VND'),
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
                        const Divider(thickness: 1.5, color: Colors.grey),
                        const SizedBox(height: 20),
                      ],

                      // Chỉ hiện thị chọn ngày giờ nếu role là 'user'
                      if (widget.currentAccount.role == 'user') ...[
                        const Text(
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
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                _addBooking(widget.currentAccount);
                                Navigator.pop(context);
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
