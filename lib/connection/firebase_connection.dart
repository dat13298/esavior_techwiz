import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
}