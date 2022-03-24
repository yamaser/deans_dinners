import 'package:deans_dinners/models/dinner.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DinnerImage extends StatelessWidget {
  final Dinner dinner;
  const DinnerImage({Key? key, required this.dinner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: CachedNetworkImage(
            imageUrl: dinner.photoUrl!,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Placeholder()),
            fit: BoxFit.cover),
      ),
    );
  }
}
