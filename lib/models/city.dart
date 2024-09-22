
import 'car.dart';
import 'hospital.dart';

class City{
  final String id;
  final String name;
  final List<Hospital> hospitals;
  final List<Car> cars;
  final String costEmergency;
  final String costNonEmergency;


  City({
    required this.id,
    required this.name,
    required this.hospitals,
    required this.cars,
    required this.costEmergency,
    required this.costNonEmergency,
  });

  static City fromMap(Map<String, dynamic> map) {
    return City(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      hospitals: (map['hospitals'] as List<dynamic>?)
          ?.map((hospitalsMap) =>
          Hospital.fromMap(hospitalsMap as Map<String,dynamic>))
          .toList() ?? [],
      cars: (map['cars'] as List<dynamic>?)
          ?.map((carsMap) =>
          Car.fromMap(carsMap as Map<String,dynamic>))
          .toList() ?? [],
      costEmergency: map['costEmergency'] as String? ?? '',
      costNonEmergency: map['costNonEmergency'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hospitals': hospitals,
      'costEmergency': costEmergency,
      'costNonEmergency': costNonEmergency,
      'cars': cars,
    };
  }
}