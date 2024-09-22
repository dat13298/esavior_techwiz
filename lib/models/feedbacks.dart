import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Feedbacks{
  final String id;
  final String content;
  final Timestamp datetime;

  Feedbacks({
    required this.id,
    required this.content,
    required this.datetime,
  });

  static Feedbacks fromMap(Map<String, dynamic> map) {
    return Feedbacks(
      id: map['id'] as String? ?? '',
      content: map['content'] as String? ?? '',
      datetime: map['datetime'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'datetime': datetime,
    };
  }

  String get formattedDateTime {
    DateTime dateTime = datetime.toDate();
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
  }
}