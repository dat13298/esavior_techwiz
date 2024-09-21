import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/account.dart';

import 'account_service.dart';

class DriverService{
  final CollectionReference _accountsCollection = FirebaseFirestore.instance.collection('account');

  Stream<List<Account>> getAllDriver() {
    return _accountsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> accData = data['account'] as List<dynamic>;
      return accData
          .map((accountData) => Account.fromMap(accountData as Map<String, dynamic>))
          .where((account) => account.role == 'driver')
          .toList();
    });
  }

  Future<void> deleteDriver(String driverId) async {
    try {
      // Lấy tài liệu đầu tiên trong collection (giả định chỉ có 1 tài liệu)
      final docSnapshot = await _accountsCollection.limit(1).get();
      if (docSnapshot.docs.isNotEmpty) {
        final docRef = docSnapshot.docs.first.reference;

        // Lấy danh sách các tài khoản
        final accounts = List<Map<String, dynamic>>.from(docSnapshot.docs.first['account']);

        // Tìm chỉ số của driver cần xóa
        final driverIndex = accounts.indexWhere((acc) => acc['phoneNumber'] == driverId);

        // Nếu tìm thấy driver, xóa driver đó khỏi mảng
        if (driverIndex != -1) {
          accounts.removeAt(driverIndex); // Xóa driver khỏi danh sách
          await docRef.update({'account': accounts}); // Cập nhật lại danh sách vào Firestore
          print('Driver with phone number $driverId deleted successfully');
        } else {
          print('Driver with phone number $driverId not found');
        }
      }
    } catch (e) {
      print('Error deleting driver: $e');
      throw e;
    }
  }


  Future<void> editDriver(String driverId, {String? newFullName, String? newHomeAdd,String? newCompAdd}) async {
    try {
      final docSnapshot = await _accountsCollection.limit(1).get();
      if (docSnapshot.docs.isNotEmpty) {
        final docRef = docSnapshot.docs.first.reference;
        final accounts = List<Map<String, dynamic>>.from(docSnapshot.docs.first['account']);

        final driverIndex = accounts.indexWhere((acc) => acc['phoneNumber'] == driverId);
        if (driverIndex != -1) {
          if (newFullName != null) accounts[driverIndex]['fullName'] = newFullName;
          if (newHomeAdd != null) accounts[driverIndex]['addressHome'] = newHomeAdd;
          if (newCompAdd != null) accounts[driverIndex]['addressCompany'] = newCompAdd;
          await docRef.update({'account': accounts});
        }
      }
    } catch (e) {
      print('Error editing driver: $e');
      throw e;
    }
  }

  Stream<List<Map<String, dynamic>>> searchDriverByName(String name) {
    return _accountsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> accData = data['account'] as List<dynamic>;
      return accData
          .where((acc) => acc['role'] == 'driver' &&
          acc['name'].toLowerCase().contains(name.toLowerCase()))
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Stream<List<Map<String, dynamic>>> searchDriverByPhone(String phone) {
    return _accountsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> accData = data['account'] as List<dynamic>;
      return accData
          .where((acc) => acc['role'] == 'driver' &&
          acc['phoneNumber'].contains(phone))
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Future<void> addDriver(String fullName, String phoneNumber, String email, String homeAddress, String companyAddress, String password) async {
    try {
      // Hash the password
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Create a new driver account
      Account newDriver = Account(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        addressHome: homeAddress,
        addressCompany: companyAddress,
        passwordHash: hashedPassword,
        feedbacks: [],  // Assuming no feedback at the time of creation
        role: "driver", // Define the role as driver
        status: "",     // You can update status based on your requirements
      );

      // Call the service to add driver
      await AccountService().addAccount(newDriver);

      print('Driver $fullName added successfully');
    } catch (e) {
      print('Error adding driver: $e');

    }
  }


}