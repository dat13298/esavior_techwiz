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

  Future<void> notifyAdmin(String rideToken, String message) async {
    String notificationToken = 'notification_${DateTime.now().millisecondsSinceEpoch}';

    Map<String, dynamic> notificationData = {
      'message': message,
      'ride_token': rideToken,
      'timestamp': ServerValue.timestamp,
    };

    try {
      await _databaseReference.child('notifications/admin_notifications').child(notificationToken).set(notificationData);
      print('Notification sent to admin');
    } catch (e) {
      print('Error sending notification to admin: $e');
    }
  }

  Future<void> updateRideStatus(String rideToken, String status) async {
    try {
      await _databaseReference.child('rides').child(rideToken).update({
        'status': status,
        'last_update': ServerValue.timestamp,
      });
      print('Ride status updated');

      // Gửi thông báo đến quản trị viên khi trạng thái thay đổi
      await notifyAdmin(rideToken, 'Ride status updated to $status');
    } catch (e) {
      print('Error updating ride status: $e');
    }
  }

  Future<void> assignDriverToRide(String rideToken, String ambulanceId) async {
    try {
      await _databaseReference.child('rides').child(rideToken).update({
        'ambulance_id': ambulanceId,
        'status': 'driver_assigned',
        'last_update': ServerValue.timestamp,
      });
      print('Driver assigned to ride $rideToken');
    } catch (e) {
      print('Error assigning driver: $e');
    }
  }

  void listenForRideUpdates() {
    _databaseReference.child('rides').onChildChanged.listen((event) {
      final rideData = event.snapshot.value as Map<dynamic, dynamic>;
      final status = rideData['status'] as String;

      if (status == 'driver_assigned') {
        print('A driver has been assigned to a ride');
      }
    });
  }


}