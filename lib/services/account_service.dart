import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/account.dart';

class AccountService {
  final CollectionReference _accountsCollection =
  FirebaseFirestore.instance.collection('account');

  Future<void> addAccount(Account account) async {
    final accountMap = account.toMap();

    // Lấy dữ liệu từ collection 'account'
    final snapshot = await _accountsCollection.get();

    // Nếu chưa có dữ liệu, thêm mới một document chứa tài khoản
    if (snapshot.docs.isEmpty) {
      await _accountsCollection.add({'accounts': [accountMap]});
    } else {
      // Nếu đã có dữ liệu, lấy document ID và cập nhật thêm tài khoản mới
      final docId = snapshot.docs.first.id;
      await _accountsCollection.doc(docId).update({
        'accounts': FieldValue.arrayUnion([accountMap])
      });
    }
  }
}
