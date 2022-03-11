import 'package:flutter/material.dart';

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar = const Icon(Icons.star, color: Colors.yellow);
  final Widget unfilledStar =
      const Icon(Icons.star_border, color: Colors.yellow);

  const StarDisplayWidget({Key? key, this.value = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return index < value ? filledStar : unfilledStar;
        }),
      ),
    );
  }
}
