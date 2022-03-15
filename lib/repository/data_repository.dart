import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';

class DataRepository {
  final CollectionReference dinnersCollection =
      FirebaseFirestore.instance.collection('dinners');

  Stream<QuerySnapshot> getDinnersStream() {
    return dinnersCollection.snapshots();
  }

  Future<QuerySnapshot> getDinnerSnapshot() {
    return dinnersCollection.get();
  }

  Future<DocumentReference> addDinner(Dinner dinner) {
    return dinnersCollection.add(dinner.toJson());
  }

  void updateDinner(Dinner dinner) async {
    await dinnersCollection.doc(dinner.referenceId).update(dinner.toJson());
  }

  void deleteDinner(Dinner dinner) async {
    await dinnersCollection.doc(dinner.referenceId).delete();
  }

  final CollectionReference entriesCollection =
      FirebaseFirestore.instance.collection('entries');

  Stream<QuerySnapshot> getEntriesStream() {
    return entriesCollection.orderBy('date', descending: true).snapshots();
  }

  Future<DocumentReference> addEntry(Entry entry) {
    return entriesCollection.add(entry.toJson());
  }

  void updateEntry(Entry entry) async {
    await entriesCollection.doc(entry.referenceId).update(entry.toJson());
  }

  void deleteEntry(Entry entry) async {
    await entriesCollection.doc(entry.referenceId).delete();
  }
}
