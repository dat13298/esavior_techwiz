import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../views/notification/emergency_notification.dart';

class EmergencyService{
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
      databaseURL: 'https://test-42ad6-default-rtdb.asia-southeast1.firebasedatabase.app/' // Thay đổi URL này thành đúng
  ).ref();

  StreamSubscription<Position>? _positionStreamSubscription;


  ///SEND LOCATION USER EMERGENCY
  Future<void> sendLocationToFirebase(double latitude, double longitude) async {
    String locationToken = 'location_${DateTime.now().millisecondsSinceEpoch}';

    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': ServerValue.timestamp,
      'status': 'not accept',
    };

    try {
      await _databaseReference.child('locations').child(locationToken).set(locationData);
      print('Location sent to Firebase');
    } catch (e) {
      print('Error sending location to Firebase: $e');
    }
  }

  ///LISTEN WHEN USER HAVE EMERGENCY AND NOTIFY TO ADMIN SCREEN
  void listenForUserLocations(BuildContext context) {
    _databaseReference.child('locations').orderByChild('status').equalTo('not accept').onChildAdded.listen((event) {
      final locationKey = event.snapshot.key as String;
      final locationData = event.snapshot.value as Map<dynamic, dynamic>;

      final latitude = locationData['latitude'] as double;
      final longitude = locationData['longitude'] as double;
      final timestamp = locationData['timestamp'] as int;
      final timestampObject = Timestamp.fromMillisecondsSinceEpoch(timestamp);
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formattedTime = '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';

      final message = 'New location received:\nLatitude: $latitude\nLongitude: $longitude\nTimestamp: $formattedTime';

      final Booking emergencyBooking = Booking(
          id: locationKey,
          carID: null,
          startLongitude: null,//if driver add when driver accept
          startLatitude: null,
          endLongitude: longitude,
          endLatitude: latitude,
          userPhoneNumber: null,
          dateTime: timestampObject,
          type: 'emergency',
          cost: null,
          status: 'waiting',
          driverPhoneNumber: null
      );
      showDialog(
        context: context,
        builder: (context) => EmergencyNotification(
          title: "Emergency!!!",
          message: message,
          onConfirm: () async {
            Navigator.of(context).pop();
            // Cập nhật trạng thái thành 'accepted' khi xác nhận
            await _databaseReference.child('locations').child(locationKey).update({
              'status': 'accepted',
            });
            //TODO: logic send booking to driver and insert booking
            print('Location status updated to accepted');
          },
        ),
      );
    });
  }

  /// Method to start listening to the driver's location and updating Firebase
  void startSendingDriverLocation(String driverPhoneNumber) {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update location every 10 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _sendDriverLocationToFirebase(driverPhoneNumber, position.latitude, position.longitude);
    });
  }

  void stopSendingDriverLocation() {
    _positionStreamSubscription?.cancel();
  }

  /// Method to send driver's location to Firebase
  Future<void> _sendDriverLocationToFirebase(String driverPhoneNumber, double latitude, double longitude) async {
    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': ServerValue.timestamp,
      'phoneNumber': driverPhoneNumber,
    };

    try {
      await _databaseReference.child('drivers_location').child(driverPhoneNumber).set(locationData);
      print('Driver location sent to Firebase');
    } catch (e) {
      print('Error sending driver location to Firebase: $e');
    }
  }

  void listenToDriverLocation(String driverPhoneNumber) {
    _databaseReference.child('drivers_location').child(driverPhoneNumber).onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];
        final timestamp = data['timestamp'];

        print('Driver location updated: Latitude: $latitude, Longitude: $longitude, Timestamp: $timestamp');

        // Xử lý logic tại đây khi có vị trí tài xế thay đổi
      } else {
        print('Driver location not found');
      }
    });
  }

  Stream<LatLng> getDriverLocationStream(String driverPhoneNumber) {
    return _databaseReference.child('drivers_location').child(driverPhoneNumber).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];

        // Trả về đối tượng LatLng2
        return LatLng(latitude, longitude);
      } else {
        // Nếu không có dữ liệu, trả về vị trí mặc định
        return LatLng(0.0, 0.0);
      }
    });
  }


}