import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/models/dinner.dart';

class Entry {
  Dinner dinner;
  DateTime date;
  num rating;
  String? comment;
  String? referenceId;

  Entry({required this.dinner, required this.date, required this.rating});

  Entry.empty()
      : dinner = Dinner.noName(),
        date = DateTime(2017, 1, 1),
        rating = 1;

  Entry.fromJson(Map<String, dynamic> json)
      : dinner = Dinner.fromJson(json['dinner']),
        date = (json['date']).toDate(),
        rating = json['rating'],
        comment = json['comment'];

  factory Entry.fromSnapshot(DocumentSnapshot snapshot) {
    final newEntry = Entry.fromJson(snapshot.data() as Map<String, dynamic>);
    newEntry.referenceId = snapshot.reference.id;
    return newEntry;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'dinner': dinner.toJson(),
        'date': Timestamp.fromDate(date),
        'rating': rating,
        'comment': comment
      };
}
