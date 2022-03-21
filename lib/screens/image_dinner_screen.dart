import 'package:cached_network_image/cached_network_image.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:flutter/material.dart';

class ImageDinnerScreen extends StatelessWidget {
  static const routeName = 'ImageDinnerScreen';
  const ImageDinnerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Dinner dinner = ModalRoute.of(context)!.settings.arguments as Dinner;
    return Scaffold(
      appBar: AppBar(
        title: Text(dinner.name),
        centerTitle: true,
        toolbarHeight: 40,
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx.abs() > 3 || details.delta.dy.abs() > 3) {
            Navigator.of(context).pop();
          }
        },
        child: Hero(
          tag: dinner.referenceId!,
          child: CachedNetworkImage(
            imageUrl: dinner.photoUrl!,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Placeholder()),
          ),
        ),
      ),
    );
  }
}
