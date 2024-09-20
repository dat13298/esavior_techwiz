import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking.dart';

class BookingService {
  final CollectionReference _bookingCollection = FirebaseFirestore.instance.collection('booking');

  // Thêm booking mới vào Firestore (ID sẽ tự động được Firestore sinh ra)
  Future<void> addBooking(Booking booking) async {
    await _bookingCollection.add([booking.toMap()]);
  }

  // Cập nhật booking theo ID
  Future<void> updateBooking(String id, Booking updatedBooking) async {
    await _bookingCollection.doc(id).update(updatedBooking.toMap());
  }

  // Xóa booking theo ID
  Future<void> deleteBooking(String id) async {
    await _bookingCollection.doc(id).delete();
  }

  // Lấy tất cả các booking từ Firestore
  Future<List<Booking>> getAllBookings() async {
    QuerySnapshot snapshot = await _bookingCollection.get();
    return snapshot.docs.map((doc) {
      return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Lấy booking theo ID
  Future<Booking?> getBookingById(String id) async {
    DocumentSnapshot doc = await _bookingCollection.doc(id).get();
    if (doc.exists) {
      return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}