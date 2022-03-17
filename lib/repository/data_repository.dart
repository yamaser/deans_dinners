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
    await deleteEntriesOnDeleteDinner(dinner);
    await dinnersCollection.doc(dinner.referenceId).delete();
  }

  final CollectionReference entriesCollection =
      FirebaseFirestore.instance.collection('entries');

  Stream<QuerySnapshot> getEntriesStream() {
    return entriesCollection.orderBy('date', descending: true).snapshots();
  }

  Future<QuerySnapshot> getEntriesSnapshot() {
    return entriesCollection.get();
  }

  Future<DocumentReference> addEntry(Entry entry) {
    return entriesCollection.add(entry.toJson());
  }

  Future<void> updateEntry(Entry entry) async {
    await entriesCollection.doc(entry.referenceId).update(entry.toJson());
  }

  Future<void> deleteEntry(Entry entry) async {
    await updateDinnerOnDeleteEntry(entry);
    await entriesCollection.doc(entry.referenceId).delete();
  }

  Future<void> deleteEntriesOnDeleteDinner(Dinner dinner) async {
    QuerySnapshot entriesSnapshot = await getEntriesSnapshot();
    for (var doc in entriesSnapshot.docs) {
      if (doc['dinner']['referenceId'] == dinner.referenceId) {
        await entriesCollection.doc(doc.reference.id).delete();
      }
    }
  }

  Future<void> updateDinnerOnDeleteEntry(Entry entry) async {
    Dinner dinner = Dinner.fromSnapshot(
        await dinnersCollection.doc(entry.dinner.referenceId).get());
    if (dinner.numRatings == 1) {
      dinner.aveRating = null;
    } else {
      dinner.aveRating =
          (dinner.numRatings * dinner.aveRating! - entry.rating) /
              (dinner.numRatings - 1);
    }
    dinner.lastFiveServeDates.removeLast();
    dinner.numRatings -= 1;
    await updateDinner(dinner);
  }
}
