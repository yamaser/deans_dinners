import 'package:deans_dinners/components/star_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EntriesScreen extends StatelessWidget {
  EntriesScreen({Key? key}) : super(key: key);

  final entries = List<String>.generate(4, (i) {
    return 'Entry $i';
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('entries').snapshots(),
        builder: (content, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var entry = snapshot.data!.docs[index];
                  return ListTile(
                    leading: const FlutterLogo(),
                    title: Text(datetimeFormat(entry['date'])),
                    subtitle: Text(entry['name'].toString()),
                    trailing: StarDisplayWidget(
                      value: entry['rating'],
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

String datetimeFormat(Timestamp timeStamp) {
  return DateFormat('MMMM d, y').format(timeStamp.toDate()).toString();
}
