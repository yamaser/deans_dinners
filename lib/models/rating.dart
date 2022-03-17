import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Rating {
  DateTime date;
  num rating;
  String? comment;
  String? referenceId;

  Rating({required this.date, required this.rating});

  Rating.fromJson(Map<String, dynamic> json)
      : date = (json['date']).toDate(),
        rating = json['rating'],
        comment = json['comment'];

  factory Rating.fromSnapshot(DocumentSnapshot snapshot) {
    final newEntry = Rating.fromJson(snapshot.data() as Map<String, dynamic>);
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
}
