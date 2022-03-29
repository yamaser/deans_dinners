import 'package:cached_network_image/cached_network_image.dart';
import 'package:deans_dinners/provider/selected_dinners.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/screens/image_dinner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with AutomaticKeepAliveClientMixin {
  final DataRepository repository = DataRepository();

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
          child: CachedNetworkImage(
            imageUrl: dinner.photoUrl!,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Center(child: Placeholder()),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void pushImageDinnerScreen(Dinner dinner, BuildContext context) {
    Navigator.of(context)
        .pushNamed(ImageDinnerScreen.routeName, arguments: dinner);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<SelectedDinners>(
      builder: (context, selectedDinners, child) {
        if (selectedDinners.selectedDinners.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              children:
                  _imageListWidgets(selectedDinners.selectedDinners, context),
            ),
          );
        } else {
          return Center(
              child: Text('No dinners selected',
                  style: Theme.of(context).textTheme.headline5));
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
