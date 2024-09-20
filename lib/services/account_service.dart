import 'package:bcrypt/bcrypt.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/account.dart';

class AccountService {
  final CollectionReference _accountsCollection =
  FirebaseFirestore.instance.collection('account');

  Future<void> addAccount(Account account) async {
    final accountMap = account.toMap();
    final snapshot = await _accountsCollection.get();

    if (snapshot.docs.isEmpty) {
      await _accountsCollection.add({'account': [accountMap]});
    } else {
      final docId = snapshot.docs.first.id;
      await _accountsCollection.doc(docId).update({
        'account': FieldValue.arrayUnion([accountMap])
      });
    }
  }


  Future<Account?> authenticate(String email, String password) async {
    try {
      final snapshot = await _accountsCollection
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // final accountData = snapshot.docs.first.data() as Map<String, dynamic>;
        DocumentSnapshot accountDoc = snapshot.docs.first;
        Map<String, dynamic> accountData = accountDoc.data() as Map<String, dynamic>;
        print(accountData.toString());
        Account account = Account.fromMap(accountData);
        final hashedPassword = accountData['passwordHash'];
        print(hashedPassword);

        if(BCrypt.checkpw(password,hashedPassword)) {
          print(account);
          return Account.fromMap(accountData);
        }
      }
    } catch (e) {
      print('Lỗi khi xác thực: $e');
      return null;
    }
    return null;
  }

}
