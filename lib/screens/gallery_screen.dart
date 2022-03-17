import 'package:deans_dinners/repository/data_repository.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/screens/image_dinner_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryScreen extends StatelessWidget {
  GalleryScreen({Key? key}) : super(key: key);
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: repository.getDinnersSnapshot(),
        builder: (content, snapshot) {
          if (snapshot.hasData) {
            final List<Dinner> dinnerList =
                Dinner.buildDinnerListFromSnapshot(snapshot);
            return Padding(
              padding: const EdgeInsets.all(2),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                children: _imageListWidgets(dinnerList, context),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  List<Widget> _imageListWidgets(
      List<Dinner> dinnerList, BuildContext context) {
    return dinnerList.map((e) => _imageWidget(e, context)).toList();
  }

  Widget _imageWidget(Dinner dinner, BuildContext context) {
    return GestureDetector(
      onTap: () => pushImageDinnerScreen(dinner, context),
      child: AspectRatio(
        aspectRatio: 1,
        child: Hero(
          tag: dinner.referenceId!,
          child: Image.network(dinner.photoUrl!, fit: BoxFit.cover),
        ),
      ),
    );
  }

  void pushImageDinnerScreen(Dinner dinner, BuildContext context) {
    Navigator.of(context)
        .pushNamed(ImageDinnerScreen.routeName, arguments: dinner);
  }
}
