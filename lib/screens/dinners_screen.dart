import 'package:deans_dinners/models/dinner.dart';
import 'package:flutter/material.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DinnersScreen extends StatelessWidget {
  final DataRepository repository = DataRepository();

  DinnersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getDinnersStream(),
        builder: (content, snapshot) {
          if (snapshot.hasData) {
            final List<Dinner> dinnerList =
                Dinner.buildDinnerListFromSnapshot(snapshot);
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return dinnerCard(context, dinnerList[index]);
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Widget dinnerCard(BuildContext context, Dinner dinner) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dinner.name,
            style: Theme.of(context).textTheme.headline5,
          ),
          Text('Last Served: ${dinner.getLastServedAsString()}'),
          Text('Average Rating: ' + dinner.getAveRating()),
          Text('Number of Ratings: ${dinner.numRatings}'),
          Text('Description: ${dinner.description}'),
        ],
      ),
    ),
  );
}
