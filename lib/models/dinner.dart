import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Dinner {
  String name;
  List<DateTime> lastFiveServeDates;
  num? aveRating;
  int numRatings;
  String? description;
  String? referenceId;

  Dinner(
      {this.name = 'no name',
      this.lastFiveServeDates = const [],
      this.aveRating,
      this.numRatings = 0,
      this.description = 'no description'});

  Dinner.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lastFiveServeDates = _convertTimestampList(json['lastFiveServeDates']),
        aveRating = json['aveRating'],
        numRatings = json['numRatings'],
        description = json['description'],
        referenceId = json['referenceId'];

  factory Dinner.fromSnapshot(DocumentSnapshot snapshot) {
    final newDinner = Dinner.fromJson(snapshot.data() as Map<String, dynamic>);
    newDinner.referenceId = snapshot.reference.id;
    return newDinner;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'lastFiveServeDates': lastFiveServeDates,
        'aveRating': aveRating,
        'numRatings': numRatings,
        'description': description,
        'referenceId': referenceId,
      };

  String getLastServedAsString() {
    return lastFiveServeDates.isEmpty
        ? 'no info'
        : DateFormat('MMMM d, y').format(lastFiveServeDates.last).toString();
  }

  String getAveRating() {
    return aveRating == null ? 'no info' : aveRating!.toStringAsFixed(1);
  }

  static List<Dinner> buildDinnerListFromSnapshot(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((e) => Dinner.fromSnapshot(e)).toList();
  }
}

List<DateTime> _convertTimestampList(List<dynamic> list) {
  if (list.isEmpty) {
    return [];
  } else {
    return list.map<DateTime>((e) => e.toDate()).toList();
  }
}
