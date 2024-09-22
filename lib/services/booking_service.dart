import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/booking.dart';

class BookingService {
  final CollectionReference _bookingCollection =
      FirebaseFirestore.instance.collection('booking');

  Future<void> addBooking(Booking booking) async {
    final newBooking = booking.toMap();

    final snapshot = await _bookingCollection.get();
    if (snapshot.docs.isEmpty) {
      await _bookingCollection.add({
        'booking': [newBooking]
      });
    } else {
      final docId = snapshot.docs.first.id;
      await _bookingCollection.doc(docId).update({
        'booking': FieldValue.arrayUnion([newBooking])
      });
    }
  }

  Future<void> deleteBooking(String id) async {
    await _bookingCollection.doc(id).delete();
  }

  Future<List<Booking>> getBookingsByStatus(String status) async {
    List<Booking> bookings = [];

    final snapshot = await _bookingCollection.get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;

      if (bookingData != null && bookingData.containsKey('booking')) {
        List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;
        for (var bookingMap in bookingsList) {
          Map<String, dynamic>? booking = bookingMap as Map<String, dynamic>?;

          if (booking != null &&
              booking['status'].toString().toLowerCase() ==
                  status.toLowerCase()) {
            Booking bookingObject = Booking.fromMap(booking, doc.id);
            bookings.add(bookingObject);
          }
        }
      }
    }
    bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return bookings;
  }

  Future<List<Booking>> getAllBookings() async {
    List<Booking> bookings = [];
    try {
      final snapshot = await _bookingCollection.get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;
        if (bookingData != null && bookingData.containsKey('booking')) {
          List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;
          for (var bookingMap in bookingsList) {
            Map<String, dynamic>? booking = bookingMap as Map<String, dynamic>?;
            if (booking != null) {
              Booking bookingObject = Booking.fromMap(booking, doc.id);
              bookings.add(bookingObject);
            }
          }
        }
      }
      bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all bookings: $e');
      }
    }
    return bookings;
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
          Map<String, dynamic>? bookingData =
              doc.data() as Map<String, dynamic>?;
          if (bookingData != null && bookingData.containsKey('booking')) {
            List<dynamic> bookingsList =
                bookingData['booking'] as List<dynamic>;
            for (var bookingMap in bookingsList) {
              Map<String, dynamic>? booking =
                  bookingMap as Map<String, dynamic>?;
              if (booking != null &&
                  booking['userPhoneNumber'] == userPhoneNumber) {
                if (kDebugMode) {
                  print('Booking data: $booking');
                }
                Booking bookingObject = Booking.fromMap(booking, doc.id);
                bookings.add(bookingObject);
              }
            }
          }
        }
      }

      bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      if (kDebugMode) {
        print("Total bookings fetched: ${bookings.length}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookings: $e');
      }
    }
    return bookings;
  }

  Future<List<Booking>> getBookingsByDriverPhoneNumber(
      String driverPhoneNumber) async {
    List<Booking> bookings = [];

    try {
      final snapshot = await _bookingCollection.get();
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          Map<String, dynamic>? bookingData =
              doc.data() as Map<String, dynamic>?;
          if (bookingData != null && bookingData.containsKey('booking')) {
            List<dynamic> bookingsList =
                bookingData['booking'] as List<dynamic>;
            for (var bookingMap in bookingsList) {
              Map<String, dynamic>? booking =
                  bookingMap as Map<String, dynamic>?;
              if (booking != null &&
                  booking['driverPhoneNumber'] == driverPhoneNumber) {
                if (kDebugMode) {
                  print('Booking data: $booking');
                }
                Booking bookingObject = Booking.fromMap(booking, doc.id);
                bookings.add(bookingObject);
              }
            }
          }
        }
      }
      bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      if (kDebugMode) {
        print("Total bookings fetched: ${bookings.length}");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookings: $e');
      }
    }
    return bookings;
  }

  Future<void> updateBooking(String bookingId, String driverPhoneNumber) async {
    try {
      final snapshot = await _bookingCollection.get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;

        if (bookingData != null && bookingData.containsKey('booking')) {
          List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;

          for (var bookingMap in bookingsList) {
            if (bookingMap['id'] == bookingId) {
              bookingMap['status'] = 'Waiting';
              bookingMap['driverPhoneNumber'] = driverPhoneNumber;
              await _bookingCollection.doc(doc.id).update({
                'booking': bookingsList,
              });
              if (kDebugMode) {
                print("Booking updated successfully.");
              }
              return;
            }
          }
        }
      }
    } catch (e) {
      print("Error updating booking: $e");
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      final snapshot = await _bookingCollection.get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic>? bookingData = doc.data() as Map<String, dynamic>?;
        if (bookingData != null && bookingData.containsKey('booking')) {
          List<dynamic> bookingsList = bookingData['booking'] as List<dynamic>;
          for (var bookingMap in bookingsList) {
            if (bookingMap['id'] == bookingId) {
              bookingMap['status'] = newStatus;
              await _bookingCollection.doc(doc.id).update({
                'booking': bookingsList,
              });
              print("Booking status updated successfully.");
              return;
            }
          }
        }
      }
    } catch (e) {
      print('Failed to update booking status: $e');
    }
  }
}