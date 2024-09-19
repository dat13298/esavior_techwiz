import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyService{
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
      databaseURL: 'https://test-42ad6-default-rtdb.asia-southeast1.firebasedatabase.app/' // Thay đổi URL này thành đúng
  ).ref();

  Future<void> sendLocationToFirebase(double latitude, double longitude) async {
    String locationToken = 'location_${DateTime.now().millisecondsSinceEpoch}';

    Map<String, dynamic> locationData = {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': ServerValue.timestamp,
    };

    try {
      await _databaseReference.child('locations').child(locationToken).set(locationData);
      print('Location sent to Firebase');
    } catch (e) {
      print('Error sending location to Firebase: $e');
    }
  }

}