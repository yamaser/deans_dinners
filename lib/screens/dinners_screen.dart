import 'package:cached_network_image/cached_network_image.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/selected_dinners.dart';
import 'package:deans_dinners/screens/details_dinner_screen.dart';
import 'package:flutter/material.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class DinnersScreen extends StatefulWidget {
  const DinnersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DinnersScreen> createState() => _DinnersScreenState();
}

class _DinnersScreenState extends State<DinnersScreen>
    with AutomaticKeepAliveClientMixin {
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

  @override
  bool get wantKeepAlive => true;
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

class _DinnerCardState extends State<DinnerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController? _controller;
  late Animation<double> _paddingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _paddingAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 8), weight: 50),
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 8, end: 0), weight: 50),
      ],
    ).animate(_controller!);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  void pushDetailsDinnerScreen(context, Dinner dinner) {
    Navigator.of(context)
        .pushNamed(DetailsDinnerScreen.routeName, arguments: dinner);
  }

  Widget selectableImage(Dinner dinner, bool isSelected) {
    if (isSelected == true) {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          AspectRatio(
            aspectRatio: 1.7,
            child: AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) {
                return Padding(
                  padding: EdgeInsets.all(_paddingAnimation.value),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.dinner.photoUrl!,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Placeholder()),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
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
      return AspectRatio(
        aspectRatio: 1.7,
        child: AnimatedBuilder(
          animation: _controller!,
          builder: (context, _) {
            return Padding(
              padding: EdgeInsets.all(_paddingAnimation.value),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  imageUrl: widget.dinner.photoUrl!,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Placeholder()),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isSelected = context.select<SelectedDinners, bool>(
        (value) => value.containsDinnerRef(widget.dinner));

    return GestureDetector(
      onTap: () => pushDetailsDinnerScreen(context, widget.dinner),
      onLongPress: () {
        var selectedDinners = context.read<SelectedDinners>();
        isSelected = !isSelected;
        if (isSelected) {
          selectedDinners.add(widget.dinner);
        } else {
          selectedDinners.remove(widget.dinner);
        }
        _controller!.reset();
        _controller!.forward();
        HapticFeedback.lightImpact();
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                child: selectableImage(widget.dinner, isSelected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
