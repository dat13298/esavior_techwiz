class Message{
  final String id;
  final String message;
  final String role;

  Message({
    required this.id,
    required this.message,
    required this.role,
  });

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String? ?? '',
      message: map['message'] as String? ?? '',
      role: map['role'] as String? ?? '',

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'role': role,
    };
  }
}