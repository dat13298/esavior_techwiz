import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esavior_techwiz/models/feedbacks.dart';

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

        // Tìm tài khoản theo email
        final index = accountList.indexWhere((acc) => acc['email'] == email);
        if (index != -1) {
          accountList[index] = accountMap; // Cập nhật tài khoản
          await _accountsCollection.doc(docId).update({
            'account': accountList,
          });
        } else {
          print('Account with email $email not found.');
        }
      }
    } catch (e) {
      print('Error updating account: $e');
    }
  }

  Future<Account?> authenticate(String email, String password) async {
    try {
      // Lấy tất cả các tài liệu từ collection
      final snapshot = await _accountsCollection.get();

      if (snapshot.docs.isNotEmpty) {
        // Lặp qua tất cả tài liệu
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? accountData =
              doc.data() as Map<String, dynamic>?;

          // Kiểm tra nếu tài liệu có trường 'account' là danh sách
          if (accountData != null && accountData.containsKey('account')) {
            List<dynamic> accounts = accountData['account'] as List<dynamic>;

            // Lặp qua từng tài khoản trong danh sách account
            for (var accountMap in accounts) {
              Map<String, dynamic>? account =
                  accountMap as Map<String, dynamic>?;

              if (account != null && account['email'] == email) {
                // In dữ liệu tài khoản khi tìm thấy email khớp
                print('Account data: $account');

                // Tạo đối tượng Account từ map data
                Account accountObject = Account.fromMap(account);

                final hashedPassword = account['passwordHash'];
                if (hashedPassword == null) {
                  print('No hashed password found.');
                  return null;
                }

                // So sánh mật khẩu
                if (BCrypt.checkpw(password, hashedPassword)) {
                  print('Authentication successful: $accountObject');
                  return accountObject;
                } else {
                  print('Password mismatch.');
                  return null;
                }
              }
            }
          }
        }

        // Nếu không tìm thấy tài khoản nào khớp với email
        print('No account found for the provided email.');
      } else {
        print('No accounts found in the collection.');
      }
    } catch (e) {
      print('Error during authentication: $e');
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
                // Thêm thông tin nghệ sĩ vào mỗi bài hát
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
