
import 'car.dart';
import 'hospital.dart';

class City{
  final String id;
  final String name;
  final List<Hospital> hospitals;
  final List<Car> cars;
  final String cost_emergency;
  final String cost_non_emergency;


  City({
    required this.id,
    required this.name,
    required this.hospitals,
    required this.cars,
    required this.cost_emergency,
    required this.cost_non_emergency,
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
      cost_emergency: map['cost_emergency'] as String? ?? '',
      cost_non_emergency: map['cost_non_emergency'] as String? ?? '',
    );
  }


  // Phương thức chuyển Album thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hospitals': hospitals,
      'cost_emergency': cost_emergency,
      'cost_non_emergency': cost_non_emergency,
      'cars': cars,
    };
  }


}