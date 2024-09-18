import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Booking {
  final String id;
  final String carID;
  final String userLongitude;
  final String userLatitude;
  final String locationLongitude;
  final String locationLatitude;
  final String userPhoneNumber;
  final Timestamp dateTime;
  final String type;
  final String cost;
  final String status;
  final String driverPhoneNumber;

  Booking({
    required this.id,
    required this.carID,
    required this.userLongitude,
    required this.userLatitude,
    required this.locationLongitude,
    required this.locationLatitude,
    required this.userPhoneNumber,
    required this.dateTime,
    required this.type,
    required this.cost,
    required this.status,
    required this.driverPhoneNumber,
  });

  static Booking fromMap(Map<String,dynamic> map){
    return Booking(
      id: map['id'] as String,
      carID: map['carID'] as String,
      userLongitude: map['userLongitude'] as String,
      userLatitude: map['userLatitude'] as String,
      locationLongitude: map['locationLongitude'] as String,
      locationLatitude: map['locationLatitude'] as String,
      userPhoneNumber: map['userPhoneNumber'] as String,
      dateTime: map['dateTime'] as Timestamp,
      type: map['type'] as String,
      cost: map['cost'] as String,
      status: map['status'] as String,
      driverPhoneNumber: map['driverPhoneNumber'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'carID':carID,
      'userLongitude':userLongitude,
      'userLatitude':userLatitude,
      'locationLongitude':locationLongitude,
      'locationLatitude':locationLatitude,
      'userPhoneNumber':userPhoneNumber,
      'dateTime':dateTime,
      'type':type,
      'cost':cost,
      'status':status,
      'driverPhoneNumber':driverPhoneNumber,
    };
  }

  String get formattedDateTime {
    // Chuyển đổi Timestamp thành DateTime
    DateTime formatDateTime = dateTime.toDate();
    // Định dạng ngày giờ
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(formatDateTime);
  }
}