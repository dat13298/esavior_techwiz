import 'feedbacks.dart';

class Account{
  final String fullName;
  final String email;
  final String phoneNumber;
  final String passwordHash;
  final String addressHome;
  final String addressCompany;
  final String role;
  final List<Feedbacks>? feedbacks;
  final String status;

  Account({
    required this.fullName,
    required this.phoneNumber,
    required this.passwordHash,
    required this.email,
    required this.addressHome,
    required this.addressCompany,
     this.feedbacks,
    required this.role,
    required this.status,
  });

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      passwordHash: map['passwordHash'] as String? ?? '',
      addressHome: map['addressHome'] as String? ?? '',
      addressCompany: map['addressCompany'] as String? ?? '',
      role: map['role'] as String? ?? '',
      status: map['status'] as String? ?? '',
      feedbacks: (map['feedbacks'] as List<dynamic>?)
          ?.map((feedbackMap) =>
          Feedbacks.fromMap(feedbackMap as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'passwordHash': passwordHash,
      'addressHome': addressHome,
      'addressCompany': addressCompany,
      'role': role,
      'feedbacks': feedbacks?.map((f) => f.toMap()).toList(),
      'status': status,
    };
  }
}