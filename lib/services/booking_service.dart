import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking.dart';

class BookingService {
  final CollectionReference _bookingCollection =
      FirebaseFirestore.instance.collection('booking');

  // Thêm booking mới vào Firestore (ID sẽ tự động được Firestore sinh ra)
  Future<void> addBooking(Booking booking) async {
    final newBooking = booking.toMap();

    final snapshot = await _bookingCollection.get();
    if(snapshot.docs.isEmpty){
      await _bookingCollection.add({'booking': [newBooking]});
    } else {
      final docId = snapshot.docs.first.id;
      await _bookingCollection.doc(docId).update({
        'booking':FieldValue.arrayUnion([newBooking])
      });
    }
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

  Future<List<Booking>> getBookingsByPhoneNumber(String userPhoneNumber) async {
    List<Booking> bookings = []; // Danh sách để lưu các booking tìm thấy

    try {
      final snapshot = await _bookingCollection.get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;

          if (bookingData != null && bookingData.containsKey('booking')) {
            List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;

            for (var bookingMap in bookingsList) {
              Map<String, dynamic>? booking = bookingMap as Map<String, dynamic>?;

              if (booking != null && booking['userPhoneNumber'] == userPhoneNumber) {
                print('Booking data: $booking');

                // Tạo đối tượng Booking từ map và thêm vào danh sách
                Booking bookingObject = Booking.fromMap(booking, doc.id);
                bookings.add(bookingObject); // Thêm booking vào danh sách
              }
            }
          }
        }
      }

      print("Total bookings fetched: ${bookings.length}");
    } catch (e) {
      print('Error fetching bookings: $e');
    }

    return bookings; // Trả về danh sách booking tìm thấy
  }




// Future<List<Booking>> getBookingsByPhoneNumber(String userPhoneNumber) async {
  //   try {
  //     // Lấy tất cả các booking từ Firestore
  //     QuerySnapshot snapshot = await _bookingCollection.get();
  //
  //     // Lọc danh sách booking theo userPhoneNumber
  //     List<Booking> bookings = snapshot.docs.map((doc) {
  //       return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  //     }).where((booking) => booking.userPhoneNumber == userPhoneNumber).toList();
  //
  //     return bookings;
  //   } catch (e) {
  //     print("Error fetching bookings: $e");
  //     return [];
  //   }
  // }



}
