import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Booking {
  final String? id;
  final String? carID;
  final double? startLongitude;
  final double? startLatitude;
  final double endLongitude;
  final double endLatitude;
  final String? userPhoneNumber;
  final Timestamp dateTime;
  final String type;
  final double? cost;
  final String status;
  final String? driverPhoneNumber;

  Booking({
    this.id,
    this.carID,
    this.startLongitude,
    this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
    this.userPhoneNumber,
    required this.dateTime,
    required this.type,
    required this.cost,
    required this.status,
    this.driverPhoneNumber,
  });

  static Booking fromMap(Map<String,dynamic> map, String id){
    return Booking(
      id: id,
      carID: map['carID'] as String,
      startLongitude: map['startLongitude'] as double,
      startLatitude: map['startLatitude'] as double,
      endLongitude: map['endLongitude'] as double,
      endLatitude: map['endLatitude'] as double,
      userPhoneNumber: map['userPhoneNumber'] as String,
      dateTime: map['dateTime'] as Timestamp,
      type: map['type'] as String,
      cost: map['cost'] as double,
      status: map['status'] as String,
      driverPhoneNumber: map['driverPhoneNumber'] as String,
    );
  }

  Map<String, dynamic> toMap(){
    return{
      // 'id' auto create on firebase
      'carID':carID,
      'userLongitude':startLongitude,
      'userLatitude':startLatitude,
      'locationLongitude':endLongitude,
      'locationLatitude':endLongitude,
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