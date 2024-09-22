import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/feedbacks.dart';
import 'package:flutter/foundation.dart';
import '../models/account.dart';

class AccountService {
  final CollectionReference _accountsCollection =
      FirebaseFirestore.instance.collection('account');

  Future<void> addAccount(Account account) async {
    final accountMap = account.toMap();
    final snapshot = await _accountsCollection.get();
    if (snapshot.docs.isEmpty) {
      await _accountsCollection.add({
        'account': [accountMap]
      });
    } else {
      final docId = snapshot.docs.first.id;
      await _accountsCollection.doc(docId).update({
        'account': FieldValue.arrayUnion([accountMap])
      });
    }
  }

  Future<void> updateAccountByEmail(String email, Account account) async {
    final accountMap = account.toMap();
    try {
      final snapshot = await _accountsCollection.get();
      if (snapshot.docs.isNotEmpty) {
        final docId = snapshot.docs.first.id;
        final accountList = snapshot.docs.first['account'] as List;

        final index = accountList.indexWhere((acc) => acc['email'] == email);
        if (index != -1) {
          accountList[index] = accountMap;
          await _accountsCollection.doc(docId).update({
            'account': accountList,
          });
        } else {
          if (kDebugMode) {
            print('Account with email $email not found.');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating account: $e');
      }
    }
  }

  Future<Account?> authenticate(String email, String password) async {
    try {
      final snapshot = await _accountsCollection.get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? accountData =
              doc.data() as Map<String, dynamic>?;

          if (accountData != null && accountData.containsKey('account')) {
            List<dynamic> accounts = accountData['account'] as List<dynamic>;

            for (var accountMap in accounts) {
              Map<String, dynamic>? account =
                  accountMap as Map<String, dynamic>?;

              if (account != null && account['email'] == email) {
                if (kDebugMode) {
                  print('Account data: $account');
                }

                Account accountObject = Account.fromMap(account);

                final hashedPassword = account['passwordHash'];
                if (hashedPassword == null) {
                  if (kDebugMode) {
                    print('No hashed password found.');
                  }
                  return null;
                }

                if (BCrypt.checkpw(password, hashedPassword)) {
                  if (kDebugMode) {
                    print('Authentication successful: $accountObject');
                  }
                  return accountObject;
                } else {
                  if (kDebugMode) {
                    print('Password mismatch.');
                  }
                  return null;
                }
              }
            }
          }
        }
        if (kDebugMode) {
          print('No account found for the provided email.');
        }
      } else {
        if (kDebugMode) {
          print('No accounts found in the collection.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during authentication: $e');
      }
    }
    return null;
  }

  Stream<List<Feedbacks>> getAllFeedBack() {
    return _accountsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return [];
      List<Feedbacks> allFeedback = [];
      var doc = snapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      final List<dynamic>? accountData = data['account'] as List<dynamic>?;

      if (accountData != null) {
        for (var account in accountData) {
          String accID = account['phoneNumber'];
          String accName = account['fullName'];

          final List<dynamic>? feedback = account['feedbacks'] as List<dynamic>?;

          if (feedback != null) {
            allFeedback.addAll(
              feedback.map((feedbackData) {
                feedbackData['phoneNumber'] = accID;
                feedbackData['fullName'] = accName;
                return Feedbacks.fromMap(feedbackData as Map<String, dynamic>);
              }).toList(),
            );
          }
        }
      }
      return allFeedback;
    });
  }
}
