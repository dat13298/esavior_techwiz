import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/account.dart';
import 'package:flutter/foundation.dart';
import 'account_service.dart';

class DriverService {
  final CollectionReference _accountsCollection =
      FirebaseFirestore.instance.collection('account');

  Stream<List<Account>> getAllDriver() {
    return _accountsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> accData = data['account'] as List<dynamic>;
      return accData
          .map((accountData) =>
              Account.fromMap(accountData as Map<String, dynamic>))
          .where((account) => account.role == 'driver')
          .toList();
    });
  }

  Future<void> deleteDriver(String driverId) async {
    try {
      final docSnapshot = await _accountsCollection.limit(1).get();
      if (docSnapshot.docs.isNotEmpty) {
        final docRef = docSnapshot.docs.first.reference;

        final accounts =
            List<Map<String, dynamic>>.from(docSnapshot.docs.first['account']);
        final driverIndex =
            accounts.indexWhere((acc) => acc['phoneNumber'] == driverId);
        if (driverIndex != -1) {
          accounts.removeAt(driverIndex);
          await docRef.update({'account': accounts});
          if (kDebugMode) {
            print('Driver with phone number $driverId deleted successfully');
          }
        } else {
          if (kDebugMode) {
            print('Driver with phone number $driverId not found');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting driver: $e');
      }
      rethrow;
    }
  }

  Future<void> editDriver(String driverId,
      {String? newFullName, String? newHomeAdd, String? newCompAdd}) async {
    try {
      final docSnapshot = await _accountsCollection.limit(1).get();
      if (docSnapshot.docs.isNotEmpty) {
        final docRef = docSnapshot.docs.first.reference;
        final accounts =
            List<Map<String, dynamic>>.from(docSnapshot.docs.first['account']);
        final driverIndex =
            accounts.indexWhere((acc) => acc['phoneNumber'] == driverId);
        if (driverIndex != -1) {
          if (newFullName != null) {
            accounts[driverIndex]['fullName'] = newFullName;
          }
          if (newHomeAdd != null) {
            accounts[driverIndex]['addressHome'] = newHomeAdd;
          }
          if (newCompAdd != null) {
            accounts[driverIndex]['addressCompany'] = newCompAdd;
          }
          await docRef.update({'account': accounts});
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing driver: $e');
      }
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> searchDriverByName(String name) {
    return _accountsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final List<dynamic> accData = data['account'] as List<dynamic>;
      return accData
          .where((acc) =>
              acc['role'] == 'driver' &&
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
          .where((acc) =>
              acc['role'] == 'driver' && acc['phoneNumber'].contains(phone))
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Future<void> addDriver(String fullName, String phoneNumber, String email,
      String homeAddress, String companyAddress, String password) async {
    try {
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      Account newDriver = Account(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        addressHome: homeAddress,
        addressCompany: companyAddress,
        passwordHash: hashedPassword,
        feedbacks: [],
        role: "driver",
        status: "",
      );
      await AccountService().addAccount(newDriver);
      if (kDebugMode) {
        print('Driver $fullName added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding driver: $e');
      }
    }
  }
}
