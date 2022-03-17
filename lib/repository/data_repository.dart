import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';

class DataRepository {
  final CollectionReference dinnersCollection =
      FirebaseFirestore.instance.collection('dinners');

  Stream<QuerySnapshot> getDinnersStream() {
    return dinnersCollection.snapshots();
  }

  Future<QuerySnapshot> getDinnersSnapshot() {
    return dinnersCollection.get();
  }

  Future<DocumentReference> addDinner(Dinner dinner) {
    return dinnersCollection.add(dinner.toJson());
  }

  Future<void> updateDinner(Dinner dinner) async {
    await dinnersCollection.doc(dinner.referenceId).update(dinner.toJson());
  }

  Future<void> deleteDinner(Dinner dinner) async {
    QuerySnapshot snapshot = await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .get();
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
    await dinnersCollection.doc(dinner.referenceId).delete();
  }

  final Query<Map<String, dynamic>> entriesCollection = FirebaseFirestore
      .instance
      .collectionGroup('entries')
      .orderBy('date', descending: true);

  Stream<QuerySnapshot> getEntriesStream() {
    return entriesCollection.snapshots();
  }

  Future<DocumentReference> addEntry(Dinner dinner, Entry entry) {
    _updateDinnerOnAddEntry(dinner, entry);
    return dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .add(entry.toJson());
  }

  Future<void> deleteEntry(Dinner dinner, Entry entry) async {
    _updateDinnerOnDeleteEntry(dinner, entry);
    await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .doc(entry.referenceId)
        .delete();
  }

  Future<void> updateEntry(Dinner dinner, Entry entry) async {
    await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .doc(entry.referenceId)
        .update(entry.toJson());
  }

  void _updateDinnerOnAddEntry(Dinner dinner, Entry entry) {
    if (dinner.numRatings == 0) {
      dinner.aveRating = entry.rating;
      dinner.lastServed = entry.date;
    } else {
      dinner.aveRating =
          (dinner.numRatings * dinner.aveRating! + entry.rating) /
              (dinner.numRatings + 1);
    }
    dinner.numRatings += 1;
    updateDinner(dinner);
  }

  void _updateDinnerOnDeleteEntry(Dinner dinner, Entry entry) {
    if (dinner.numRatings == 1) {
      dinner.aveRating = null;
    } else {
      dinner.aveRating =
          (dinner.numRatings * dinner.aveRating! - entry.rating) /
              (dinner.numRatings + 1);
    }
    dinner.numRatings -= 1;
    updateDinner(dinner);
  }
}
