class Hospital{
  final String id;
  final String name;
  final String district;


  Hospital({
    required this.id,
    required this.name,
    required this.district,
  });

  static Hospital fromMap(Map<String, dynamic> map) {
    return Hospital(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      district: map['district'] as String? ?? '',
    );
  }

  // Phương thức chuyển Album thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'district': district,
    };
  }

}