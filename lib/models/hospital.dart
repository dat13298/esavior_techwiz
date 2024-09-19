class Hospital{
  final String id;
  final String name;
  final String address;
  final String cityID;


  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.cityID,
  });

  static Hospital fromMap(Map<String, dynamic> map) {
    return Hospital(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      address: map['address'] as String? ?? '',
      cityID: map['cityID'] as String? ?? '',
    );
  }

  // Phương thức chuyển Album thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'cityID':cityID,
    };
  }

}