import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/selected_dinners.dart';
import 'package:deans_dinners/screens/details_dinner_screen.dart';
import 'package:flutter/material.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DinnersScreen extends StatelessWidget {
  final DataRepository repository = DataRepository();

  DinnersScreen({
    Key? key,
  }) : super(key: key);

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
                  return DinnerCard(
                    context: context,
                    dinner: dinnerList[index],
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class DinnerCard extends StatefulWidget {
  final Dinner dinner;
  final BuildContext context;

  const DinnerCard({
    Key? key,
    required this.context,
    required this.dinner,
  }) : super(key: key);

  @override
  State<DinnerCard> createState() => _DinnerCardState();
}

class _DinnerCardState extends State<DinnerCard> {
  bool selected = false;

  void pushDetailsDinnerScreen(context, Dinner dinner) {
    Navigator.of(context)
        .pushNamed(DetailsDinnerScreen.routeName, arguments: dinner);
  }

  Widget selectableImage(Dinner dinner) {
    if (selected == true) {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: Image.network(widget.dinner.photoUrl!, fit: BoxFit.cover),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          )
        ],
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: AspectRatio(
          aspectRatio: 1.7,
          child: Image.network(widget.dinner.photoUrl!, fit: BoxFit.cover),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pushDetailsDinnerScreen(context, widget.dinner),
      onLongPress: () {
        var selectedDinners = context.read<SelectedDinners>();
        selected = !selected;
        if (selected) {
          selectedDinners.add(widget.dinner);
        } else {
          selectedDinners.remove(widget.dinner);
        }
        setState(() {});
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dinner.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                          'Last Served: ${widget.dinner.getLastServedAsString()}'),
                      Text('Average Rating: ' + widget.dinner.getAveRating()),
                      Text('Number of Ratings: ${widget.dinner.numRatings}'),
                      Text('Description: ${widget.dinner.description}'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: selectableImage(widget.dinner),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
