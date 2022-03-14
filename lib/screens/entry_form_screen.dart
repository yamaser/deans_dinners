import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';

class EntryFormScreen extends StatefulWidget {
  static const routeName = 'entryFormScreen';

  const EntryFormScreen({Key? key}) : super(key: key);

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final formKey = GlobalKey<FormState>();
  DataRepository repository = DataRepository();
  Entry entry = Entry.empty();
  DateTime selectedDate = DateTime.now();

  Future pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (pickedDate == null) return;
    setState(() => selectedDate = pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Entry'),
          backgroundColor: Colors.black,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: repository.getDinnersStream(),
          builder: (content, snapshot) {
            if (snapshot.hasData) {
              final List<Dinner> dinnerList = _buildDinnerList(snapshot);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Dean\'s Dinner',
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text('Select a dinner'),
                            autofocus: true,
                            value: dinnerList[0],
                            items: _buildDropdownMenuItems(dinnerList),
                            onChanged: (item) {},
                            onSaved: (value) {
                              entry.dinner = (value as Dinner);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              labelText: 'Rating',
                              border: OutlineInputBorder(),
                            ),
                            value: 3,
                            items: [0, 1, 2, 3, 4, 5]
                                .map((item) => DropdownMenuItem(
                                      child: Text(item.toString()),
                                      value: item,
                                    ))
                                .toList(),
                            onChanged: (item) {},
                            onSaved: (value) {
                              entry.rating = value as int;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                              text:
                                  '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
                          onTap: () => pickDate(context),
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            entry.date = selectedDate;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Comments',
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            entry.comment = value;
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            formKey.currentState!.save();
                            updateDinner(entry, repository);
                            repository.addEntry(entry);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Submit')),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

List<Dinner> _buildDinnerList(AsyncSnapshot<QuerySnapshot> snapshot) {
  return snapshot.data!.docs.map((e) => Dinner.fromSnapshot(e)).toList();
}

List<DropdownMenuItem<Dinner>> _buildDropdownMenuItems(
    List<Dinner> dinnerList) {
  return dinnerList.map((e) {
    return DropdownMenuItem(child: Text(e.name), value: e);
  }).toList();
}

void updateDinner(Entry entry, DataRepository repository) {
  entry.dinner.lastServed ??= entry.date;
  if (entry.date.isAfter(entry.dinner.lastServed!)) {
    entry.dinner.lastServed = entry.date;
  }
  if (entry.dinner.numRatings != 0) {
    entry.dinner.aveRating =
        ((entry.dinner.numRatings! * entry.dinner.aveRating!) + entry.rating) /
            (entry.dinner.numRatings! + 1);
    entry.dinner.numRatings = entry.dinner.numRatings! + 1;
  } else {
    entry.dinner.aveRating = entry.rating;
    entry.dinner.numRatings = 1;
  }
  repository.updateDinner(entry.dinner);
}
