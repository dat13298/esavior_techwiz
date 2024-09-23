import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:esavior_techwiz/models/booking.dart';
import 'package:esavior_techwiz/services/booking_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../views/notification/emergency_notification.dart';
import 'notification_provider.dart';

class EmergencyService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://test-42ad6-default-rtdb.asia-southeast1.firebasedatabase.app/'
          )
      .ref();
  StreamSubscription<Position>? _positionStreamSubscription;

  Future<void> sendLocationToFirebase(double latitude, double longitude, Account? account) async {
    String locationToken = 'location_${DateTime.now().millisecondsSinceEpoch}';
    String phone;
    phone = account != null ? account.phoneNumber : '';
    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'userPhoneNumber': phone,
      'timestamp': ServerValue.timestamp,
      'status': 'not accept',
    };
    try {
      await _databaseReference
          .child('locations')
          .child(locationToken)
          .set(locationData);
      if (kDebugMode) {
        print('Location sent to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending location to Firebase: $e');
      }
    }
  }

  void listenForUserLocations(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    _databaseReference
        .child('locations')
        .orderByChild('status')
        .equalTo('not accept')
        .onChildAdded
        .listen((event) {
      final locationKey = event.snapshot.key as String;
      final locationData = event.snapshot.value as Map<dynamic, dynamic>;
      final latitude = locationData['latitude'] as double;
      final longitude = locationData['longitude'] as double;
      final userPhoneNumber = locationData['phoneNumber']?.toString() ?? 'Don\'t have phone';

      final timestamp = locationData['timestamp'] as int;
      final timestampObject = Timestamp.fromMillisecondsSinceEpoch(timestamp);
      final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final formattedTime =
          '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
      final message =
          'New location received:\nLatitude: $latitude\nLongitude: $longitude\nTimestamp: $formattedTime';
      if (kDebugMode) {
        print("Listen success");
      }
      Booking newBooking = Booking(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          endLongitude: longitude,
          endLatitude: latitude,
          userPhoneNumber: userPhoneNumber,
          dateTime: timestampObject,
          type: "Emergency",
          status: "Not Yet Confirm");
      BookingService().addBooking(newBooking);
      notificationProvider.setMessage(message);
      if (notificationProvider.isAdmin) {
        showDialog(
          context: context,
          builder: (context) => EmergencyNotification(
            title: "Emergency!!!",
            message: message,
            onConfirm: () async {
              Navigator.of(context).pop();
              await _databaseReference
                  .child('locations')
                  .child(locationKey)
                  .update({
                'status': 'accepted',
              });
              if (kDebugMode) {
                print('Location status updated to accepted');
              }
            },
          ),
        );
      } else {
        if (kDebugMode) {
          print("This not admin");
        }
      }
    });
  }

  void startSendingDriverLocation(String driverPhoneNumber) {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    _positionStreamSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      _sendDriverLocationToFirebase(
          driverPhoneNumber, position.latitude, position.longitude);
    });
  }

  void stopSendingDriverLocation() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> _sendDriverLocationToFirebase(
      String driverPhoneNumber, double latitude, double longitude) async {
    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': ServerValue.timestamp,
      'phoneNumber': driverPhoneNumber,
    };

    try {
      await _databaseReference
          .child('drivers_location')
          .child(driverPhoneNumber)
          .set(locationData);
      if (kDebugMode) {
        print('Driver location sent to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending driver location to Firebase: $e');
      }
    }
  }

  void listenToDriverLocation(String driverPhoneNumber) {
    _databaseReference
        .child('drivers_location')
        .child(driverPhoneNumber)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];
        final timestamp = data['timestamp'];
        if (kDebugMode) {
          print(
              'Driver location updated: Latitude: $latitude, Longitude: $longitude, Timestamp: $timestamp');
        }
      } else {
        if (kDebugMode) {
          print('Driver location not found');
        }
      }
    });
  }

  Stream<LatLng> getDriverLocationStream(String driverPhoneNumber) {
    return _databaseReference
        .child('drivers_location')
        .child(driverPhoneNumber)
        .onValue
        .map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];
        return LatLng(latitude, longitude);
      } else {
        return const LatLng(0.0, 0.0);
      }
    });
  }
}
