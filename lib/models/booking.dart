import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Booking {
  final String id;
  final String? carID;
  final double? startLongitude;
  final double? startLatitude;
  final double? endLongitude;
  final double? endLatitude;
  final String? userPhoneNumber;
  final Timestamp dateTime;
  final String type;
  final double? cost;
  final String status;
  final String? driverPhoneNumber;

  Booking({
    required this.id,
    this.carID,
    this.startLongitude,
    this.startLatitude,
    required this.endLongitude,
    required this.endLatitude,
    this.userPhoneNumber,
    required this.dateTime,
    required this.type,
     this.cost,
    required this.status,
    this.driverPhoneNumber,
  });

  static Booking fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: map['id'] as String? ?? '',
      carID: map['carID'] as String? ?? '', // Gán giá trị mặc định nếu null
      startLongitude: (map['startLongitude'] as num?)?.toDouble() ?? 0.0, // Chuyển từ num (int hoặc double) thành double
      startLatitude: (map['startLatitude'] as num?)?.toDouble() ?? 0.0,
      endLongitude: (map['endLongitude'] as num?)?.toDouble() ?? 0.0,
      endLatitude: (map['endLatitude'] as num?)?.toDouble() ?? 0.0,
      userPhoneNumber: map['userPhoneNumber'] as String? ?? '', // Gán giá trị mặc định nếu null
      dateTime: map['dateTime'] as Timestamp,
      type: map['type'] as String? ?? 'unknown', // Gán giá trị mặc định
      cost: (map['cost'] as num?)?.toDouble() ?? 0.0, // Chuyển từ num (int hoặc double) thành double
      status: map['status'] as String? ?? 'unknown',
      driverPhoneNumber: map['driverPhoneNumber'] as String? ?? '', // Gán giá trị mặc định nếu null
    );
  }



  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'carID':carID,
      'startLongitude':startLongitude,
      'startLatitude':startLatitude,
      'endLongitude':endLongitude,
      'endLatitude':endLongitude,
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

  @override
  String toString() {
    return 'Booking{id: $id, carID: $carID, startLongitude: $startLongitude, startLatitude: $startLatitude, endLongitude: $endLongitude, endLatitude: $endLatitude, userPhoneNumber: $userPhoneNumber, dateTime: $dateTime, type: $type, cost: $cost, status: $status, driverPhoneNumber: $driverPhoneNumber}';
  }
}