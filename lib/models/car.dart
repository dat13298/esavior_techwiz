class Car{
  final String id;
  final String name;
  final List<String> equipment;
  final String description;
  final String image_source;
  final String num_seat;
  final String driverPhoneNumber;


  Car({
    required this.id,
    required this.name,
    required this.equipment,
    required this.description,
    required this.image_source,
    required this.num_seat,
    required this.driverPhoneNumber,
  });

  static Car fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as String,
      name: map['name'] as String,
      equipment: List<String>.from(map['equipment'] as List<dynamic>),
      description: map['description'] as String,
      image_source: map['image_source'] as String,
      num_seat: map['num_seat'] as String,
      driverPhoneNumber: map['driverPhoneNumber'] as String,
    );
  }

  // Phương thức chuyển Album thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'equipment': equipment,
      'description': description,
      'image_source': image_source,
      'num_seat': num_seat,
      'driverPhoneNumber':driverPhoneNumber,
    };
  }

}