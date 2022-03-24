import 'package:deans_dinners/components/dinner_image.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/selected_dinners.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:deans_dinners/screens/edit_dinner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class DetailsDinnerScreen extends StatefulWidget {
  static const routeName = 'DetailsDinnerScreen';
  const DetailsDinnerScreen({Key? key}) : super(key: key);

  @override
  State<DetailsDinnerScreen> createState() => _DetailsDinnerScreenState();
}

class _DetailsDinnerScreenState extends State<DetailsDinnerScreen> {
  final DataRepository repository = DataRepository();
  Dinner dinner = Dinner();

  void pushEditDinnerScreen() {
    Navigator.of(context)
        .pushNamed(EditDinnerScreen.routeName, arguments: dinner)
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    dinner = ModalRoute.of(context)!.settings.arguments as Dinner;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dinner Details'),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx.abs() > 3 || details.delta.dy.abs() > 3) {
            Navigator.of(context).pop();
          }
        },
        child: Column(
          children: [
            SelectableImage(dinner: dinner),
            Card(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: pushEditDinnerScreen,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    context.read<SelectedDinners>().remove(dinner);
                    await repository.deleteDinner(dinner);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectableImage extends StatefulWidget {
  final Dinner dinner;
  const SelectableImage({Key? key, required this.dinner}) : super(key: key);

  @override
  State<SelectableImage> createState() => _SelectableImageState();
}

class _SelectableImageState extends State<SelectableImage>
    with SingleTickerProviderStateMixin {
  bool isSelected = false;

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
            tween: Tween<double>(begin: 4, end: 12), weight: 50),
        TweenSequenceItem<double>(
            tween: Tween<double>(begin: 12, end: 4), weight: 50),
      ],
    ).animate(_controller!);
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Widget dinnerImage(Dinner dinner) {
    if (isSelected == true) {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          DinnerImage(dinner: dinner),
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
      return DinnerImage(dinner: dinner);
    }
  }

  @override
  Widget build(BuildContext context) {
    isSelected = context.select<SelectedDinners, bool>(
        (value) => value.containsDinnerRef(widget.dinner));
    return GestureDetector(
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
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (context, _) {
          return Padding(
            padding: EdgeInsets.all(_paddingAnimation.value),
            child: dinnerImage(widget.dinner),
          );
        },
      ),
    );
  }
}
