import 'package:deans_dinners/components/dinner_image.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/models/screen_arguments.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:deans_dinners/screens/edit_entry_screen.dart';
import 'package:flutter/material.dart';

class DetailsEntryScreen extends StatefulWidget {
  static const routeName = 'DetailsEntryScreen';

  const DetailsEntryScreen({Key? key}) : super(key: key);

  @override
  State<DetailsEntryScreen> createState() => _DetailsEntryScreenState();
}

class _DetailsEntryScreenState extends State<DetailsEntryScreen> {
  final DataRepository repository = DataRepository();

  void pushEditEntryScreen(BuildContext context, Dinner dinner, Entry entry) {
    Navigator.of(context)
        .pushNamed(EditEntryScreen.routeName,
            arguments: ScreenArguments(dinner, entry))
        .whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    Dinner dinner = args.dinner;
    Entry entry = args.entry;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Details'),
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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: DinnerImage(dinner: dinner),
            ),
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
                        Text('Date: ${entry.getDateAsString()}'),
                        Text('Rating: ${entry.rating}'),
                        Text('Comment: ${entry.getComment()}'),
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
                  onPressed: () => pushEditEntryScreen(context, dinner, entry),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    await repository.deleteEntry(dinner, entry);
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
