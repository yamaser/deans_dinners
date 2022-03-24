import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Entry {
  DateTime date;
  num rating;
  String? comment;
  String? referenceId;

  Entry({required this.date, required this.rating});

  Entry.fromJson(Map<String, dynamic> json)
      : date = (json['date']).toDate(),
        rating = json['rating'],
        comment = json['comment'];

  factory Entry.fromSnapshot(DocumentSnapshot snapshot) {
    final newEntry = Entry.fromJson(snapshot.data() as Map<String, dynamic>);
    newEntry.referenceId = snapshot.reference.id;
    return newEntry;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': Timestamp.fromDate(date),
        'rating': rating,
        'comment': comment
      };

  String getDateAsString() {
    return DateFormat('MMMM d, y').format(date).toString();
  }

  String? getComment() {
    return comment ?? '';
  }
}
