import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';

class DetailsDinnerScreen extends StatelessWidget {
  static const routeName = 'DetailsDinnerScreen';
  DetailsDinnerScreen({Key? key}) : super(key: key);
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    final Dinner dinner = ModalRoute.of(context)!.settings.arguments as Dinner;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinner Details'),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: Column(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(dinner.photoUrl!)),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    Column(
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
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await repository.deleteDinner(dinner);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          )
        ],
      ),
    );
  }
}
