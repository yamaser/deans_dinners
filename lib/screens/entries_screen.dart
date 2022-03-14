import 'package:deans_dinners/components/star_display.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EntriesScreen extends StatelessWidget {
  final DataRepository repository = DataRepository();

  EntriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: repository.getEntriesStream(),
        builder: (content, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Entry entry = Entry.fromSnapshot(snapshot.data!.docs[index]);
                  return ListTile(
                    leading: const FlutterLogo(),
                    title: Text(datetimeFormat(entry.date)),
                    subtitle: Text(entry.dinner.name),
                    trailing: StarDisplayWidget(
                      value: entry.rating as int,
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

String datetimeFormat(DateTime datetime) {
  return DateFormat('MMMM d, y').format(datetime).toString();
}
