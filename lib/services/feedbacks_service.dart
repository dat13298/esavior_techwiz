import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbacksService {

  final CollectionReference _accountsCollection =
  FirebaseFirestore.instance.collection('account');

  Future<void> addFeedbackByEmail(String email, String content, Timestamp datetime) async {
    try {
      DocumentSnapshot feedBackSnapshot = await _accountsCollection.doc('fNaPyfHH0NaHNuvT7JpD').get();

      if (feedBackSnapshot.exists) {
        Map<String, dynamic> data = feedBackSnapshot.data() as Map<String, dynamic>;
        List accounts = data['account'];

        // Tìm tài khoản theo email
        int accountIndex = accounts.indexWhere((account) => account['email'] == email);
        if (accountIndex != -1) {
          List<dynamic> feedbacks = accounts[accountIndex]['feedbacks'] ?? [];

          feedbacks.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'datetime': datetime,
          });

          accounts[accountIndex]['feedbacks'] = feedbacks;

          await _accountsCollection.doc('fNaPyfHH0NaHNuvT7JpD').update({'account': accounts});
          print('Feedback added successfully');
        } else {
          print('Account not found for email: $email');
        }
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error adding feedback: $e');
    }
  }





}
