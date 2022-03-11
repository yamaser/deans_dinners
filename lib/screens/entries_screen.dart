import 'package:flutter/material.dart';

class EntriesScreen extends StatelessWidget {
  EntriesScreen({Key? key}) : super(key: key);

  final entries = List<String>.generate(4, (i) {
    return 'Entry $i';
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return const ListTile(
            leading: FlutterLogo(),
            title: Text('Date'),
            subtitle: Text('Dinner Name'),
          );
        });
  }
}
