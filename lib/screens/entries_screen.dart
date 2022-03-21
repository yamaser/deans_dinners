import 'package:cached_network_image/cached_network_image.dart';
import 'package:deans_dinners/components/star_display.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({Key? key}) : super(key: key);

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen>
    with AutomaticKeepAliveClientMixin {
  final DataRepository repository = DataRepository();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: repository.getDinnersStream(),
      builder: (content, snapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: repository.getEntriesStream(),
          builder: (content, snapshot) {
            if (snapshot.hasData) {
              final List<Entry> entriesList = snapshot.data!.docs
                  .map((e) => Entry.fromSnapshot(e))
                  .toList();
              return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                        future: snapshot
                            .data!.docs[index].reference.parent.parent!
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Dinner dinner = Dinner.fromSnapshot(snapshot.data!);
                            return slidable(entriesList[index], dinner,
                                repository, context);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        });
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}

Widget imageIcon(Dinner dinner) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: CachedNetworkImage(
      imageUrl: dinner.photoUrl!,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Center(child: Placeholder()),
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      alignment: FractionalOffset.center,
    ),
  );
}

String datetimeFormat(DateTime datetime) {
  return DateFormat('MMMM d, y').format(datetime).toString();
}

Widget slidable(Entry entry, Dinner dinner, DataRepository repository,
    BuildContext context) {
  return Slidable(
    endActionPane: ActionPane(
      extentRatio: 0.2,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
            onPressed: ((context) => repository.deleteEntry(dinner, entry)),
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: 'Delete')
      ],
    ),
    child: ListTile(
      leading: imageIcon(dinner),
      title: Text(entry.getDateAsString()),
      subtitle: Text(dinner.name),
      trailing: StarDisplayWidget(
        value: entry.rating as int,
      ),
    ),
  );
}
