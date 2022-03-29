import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';

class DataRepository {
  final CollectionReference dinnersCollection =
      FirebaseFirestore.instance.collection('dinners');

  Stream<QuerySnapshot> getDinnersStream() {
    return dinnersCollection.orderBy('lastServed').snapshots();
  }

  Future<QuerySnapshot> getDinnersSnapshot() {
    return dinnersCollection.get();
  }

  Future<DocumentSnapshot> getDinnerDocument(Dinner dinner) {
    return dinnersCollection.doc(dinner.referenceId).get();
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

  Future<void> addEntry(Dinner dinner, Entry entry) async {
    await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .add(entry.toJson());
    await _updateDinnerOnAddEntry(dinner);
  }

  Future<void> deleteEntry(Dinner dinner, Entry entry) async {
    await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .doc(entry.referenceId)
        .delete();
    await _updateDinnerOnDeleteEntry(dinner);
  }

  Future<void> updateEntry(
      Dinner oldDinner, Dinner newDinner, Entry entry) async {
    await deleteEntry(oldDinner, entry);
    await addEntry(newDinner, entry);
  }

  Future<void> _updateDinnerOnAddEntry(Dinner dinner) async {
    num sum = 0;
    var querySnapshot = await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .orderBy('date', descending: true)
        .get();
    dinner.numRatings = querySnapshot.docs.length;
    for (var doc in querySnapshot.docs) {
      sum += doc['rating'];
    }
    dinner.aveRating = sum / dinner.numRatings;
    dinner.lastServed = querySnapshot.docs.first['date'].toDate();
    await updateDinner(dinner);
  }

  Future<void> _updateDinnerOnDeleteEntry(Dinner dinner) async {
    num sum = 0;
    var querySnapshot = await dinnersCollection
        .doc(dinner.referenceId)
        .collection('entries')
        .orderBy('date', descending: true)
        .get();
    dinner.numRatings = querySnapshot.docs.length;
    if (dinner.numRatings == 0) {
      dinner.aveRating = null;
      dinner.lastServed = null;
    } else {
      for (var doc in querySnapshot.docs) {
        sum += doc['rating'];
      }
      dinner.aveRating = sum / dinner.numRatings;
      dinner.lastServed = querySnapshot.docs.first['date'].toDate();
    }
    await updateDinner(dinner);
  }
}
