import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/models/rating.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Dinner {
  String name;
  DateTime? lastServed;
  num? aveRating;
  int numRatings;
  String? description;
  String? photoUrl;
  String? referenceId;
  List<Rating>? ratingsList;

  Dinner({
    this.name = 'no name',
    this.lastServed,
    this.aveRating,
    this.numRatings = 0,
    this.description = 'no description',
    this.ratingsList = const [],
  });

  Dinner.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lastServed = (json['lastServed']?.toDate()),
        aveRating = json['aveRating'],
        numRatings = json['numRatings'],
        description = json['description'],
        photoUrl = json['photoUrl'],
        referenceId = json['referenceId'];

  factory Dinner.fromSnapshot(DocumentSnapshot snapshot) {
    final newDinner = Dinner.fromJson(snapshot.data() as Map<String, dynamic>);
    newDinner.referenceId = snapshot.reference.id;
    return newDinner;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'lastServed':
            lastServed == null ? null : Timestamp.fromDate(lastServed!),
        'aveRating': aveRating,
        'numRatings': numRatings,
        'description': description,
        'photoUrl': photoUrl,
        'referenceId': referenceId,
      };

  String getLastServedAsString() {
    return lastServed == null
        ? 'no info'
        : DateFormat('MMMM d, y').format(lastServed!).toString();
  }

  String getAveRating() {
    return aveRating == null ? 'no info' : aveRating!.toStringAsFixed(1);
  }

  static List<Dinner> buildDinnerListFromSnapshot(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((e) => Dinner.fromSnapshot(e)).toList();
  }
}
