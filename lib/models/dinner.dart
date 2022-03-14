import 'package:cloud_firestore/cloud_firestore.dart';

class Dinner {
  String name;
  DateTime? lastServed;
  num? aveRating;
  int? numRatings;
  String? description;
  String? referenceId;

  Dinner(
      {required this.name,
      this.lastServed,
      this.aveRating,
      this.numRatings = 0,
      this.description});

  Dinner.noName() : name = 'no name';

  Dinner.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lastServed = json['lastServed'].toDate(),
        aveRating = json['aveRating'],
        numRatings = json['numRatings'],
        description = json['description'];

  factory Dinner.fromSnapshot(DocumentSnapshot snapshot) {
    final newDinner = Dinner.fromJson(snapshot.data() as Map<String, dynamic>);
    newDinner.referenceId = snapshot.reference.id;
    return newDinner;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'lastServed': lastServed,
        'aveRating': aveRating,
        'numRatings': numRatings,
        'description': description,
      };
}
