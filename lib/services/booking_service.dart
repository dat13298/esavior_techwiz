import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking.dart';

class BookingService {
  final CollectionReference _bookingCollection =
      FirebaseFirestore.instance.collection('booking');

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

  Future<void> updateBooking(String id, Booking updatedBooking) async {
    await _bookingCollection.doc(id).update(updatedBooking.toMap());
  }

  Future<void> deleteBooking(String id) async {
    await _bookingCollection.doc(id).delete();
  }

  Future<List<Booking>> getAllBookings() async {
    QuerySnapshot snapshot = await _bookingCollection.get();
    return snapshot.docs.map((doc) {
      return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<Booking?> getBookingById(String id) async {
    DocumentSnapshot doc = await _bookingCollection.doc(id).get();
    if (doc.exists) {
      return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
  Future<List<Booking>> getBookingsByPhoneNumber(String userPhoneNumber) async {
    List<Booking> bookings = [];
    try {
      final snapshot = await _bookingCollection.get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;

          if (bookingData != null && bookingData.containsKey('booking')) {
            List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;

            for (var bookingMap in bookingsList) {
              Map<String, dynamic>? booking = bookingMap as Map<String, dynamic>?;

              // Kiểm tra nếu số điện thoại của user trong booking khớp với userPhoneNumber
              if (booking != null && booking['userPhoneNumber'] == userPhoneNumber) {
                print('Booking data: $booking');

                Booking bookingObject = Booking.fromMap(booking, doc.id);
                bookings.add(bookingObject); // Thêm booking vào danh sách
              }
            }
          }
        }
      }
      // Sắp xếp danh sách theo thời gian đặt (dateTime)
      bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Sắp xếp giảm dần (mới nhất trước)

      print("Total bookings fetched: ${bookings.length}");
    } catch (e) {
      print('Error fetching bookings: $e');
    }

    return bookings; // Trả về danh sách đã sắp xếp
  }

  Future<List<Booking>> getBookingsByDriverPhoneNumber(String driverPhoneNumber) async {
    List<Booking> bookings = [];

    try {
      final snapshot = await _bookingCollection.get();

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;

          if (bookingData != null && bookingData.containsKey('booking')) {
            List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;

            for (var bookingMap in bookingsList) {
              Map<String, dynamic>? booking = bookingMap as Map<String, dynamic>?;

              // Kiểm tra nếu số điện thoại của user trong booking khớp với userPhoneNumber
              if (booking != null && booking['driverPhoneNumber'] == driverPhoneNumber) {
                print('Booking data: $booking');

                Booking bookingObject = Booking.fromMap(booking, doc.id);
                bookings.add(bookingObject); // Thêm booking vào danh sách
              }
            }
          }
        }
      }
      // Sắp xếp danh sách theo thời gian đặt (dateTime)
      bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Sắp xếp giảm dần (mới nhất trước)

      print("Total bookings fetched: ${bookings.length}");
    } catch (e) {
      print('Error fetching bookings: $e');
    }

    return bookings; // Trả về danh sách đã sắp xếp
  }
}
