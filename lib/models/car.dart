class Car{
  final String id;
  final String name;
  final String description;
  final String num_seat;
  final String driverPhoneNumber;
  final String cityID;

  Car({
    required this.id,
    required this.name,
    required this.description,
    required this.num_seat,
    required this.driverPhoneNumber,
    required this.cityID,
  });

  static Car fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] as String? ?? '', // Giá trị mặc định nếu là null
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      num_seat: map['num_seat'] as String? ?? '',
      driverPhoneNumber: map['driverPhoneNumber'] as String? ?? '',
      cityID: map['cityID'] as String? ?? '',
    );
  }


  // Phương thức chuyển Album thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'num_seat': num_seat,
      'driverPhoneNumber':driverPhoneNumber,
      'cityID':cityID,
    };
  }

}