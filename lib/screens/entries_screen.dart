import 'package:deans_dinners/components/star_display.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
                  return slidable(entry, repository, context);
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

Widget imageIcon_1(Entry entry, BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Image(
      image: NetworkImage(entry.dinner.photoUrl!),
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      alignment: FractionalOffset.center,
    ),
  );
}

Widget imageIcon_2(Entry entry) {
  return CircleAvatar(backgroundImage: NetworkImage(entry.dinner.photoUrl!));
}

String datetimeFormat(DateTime datetime) {
  return DateFormat('MMMM d, y').format(datetime).toString();
}

Widget slidable(Entry entry, DataRepository repository, BuildContext context) {
  return Slidable(
    endActionPane: ActionPane(
      extentRatio: 0.2,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
            onPressed: ((context) => deleteEntry(entry, repository)),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete')
      ],
    ),
    child: ListTile(
      leading: imageIcon_1(entry, context),
      title: Text(entry.getDateAsString()),
      subtitle: Text(entry.dinner.name),
      trailing: StarDisplayWidget(
        value: entry.rating as int,
      ),
    ),
  );
}

void deleteEntry(Entry entry, DataRepository repository) {
  updateDinner(entry, repository);
  repository.deleteEntry(entry);
}

void updateDinner(Entry entry, DataRepository repository) async {
  if (entry.dinner.numRatings == 1) {
    entry.dinner.aveRating = null;
  } else {
    entry.dinner.aveRating =
        (entry.dinner.numRatings * entry.dinner.aveRating! - entry.rating) /
            (entry.dinner.numRatings - 1);
  }
  entry.dinner.lastFiveServeDates.removeLast();
  entry.dinner.numRatings -= 1;
  repository.updateDinner(entry.dinner);
}
