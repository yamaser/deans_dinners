import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/components/date_picker_form_field.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';

class AddEntryFormScreen extends StatefulWidget {
  static const routeName = 'AddEntryFormScreen';

  const AddEntryFormScreen({Key? key}) : super(key: key);

  @override
  State<AddEntryFormScreen> createState() => _AddEntryFormScreenState();
}

class _AddEntryFormScreenState extends State<AddEntryFormScreen> {
  final formKey = GlobalKey<FormState>();
  DataRepository repository = DataRepository();
  Entry entry = Entry(date: DateTime.now(), rating: 0);
  DateTime selectedDate = DateTime.now();
  Dinner selectedDinner = Dinner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Entry'),
          toolbarHeight: 40,
          //backgroundColor: Colors.black,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: repository.getDinnersStream(),
          builder: (content, snapshot) {
            if (snapshot.hasData) {
              final List<Dinner> dinnerList =
                  Dinner.buildDinnerListFromSnapshot(snapshot);
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
                              selectedDinner = (value as Dinner);
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
                      DatePickerFormField(entry: entry),
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
                            repository.addEntry(selectedDinner, entry);
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

  List<DropdownMenuItem<Dinner>> _buildDropdownMenuItems(
      List<Dinner> dinnerList) {
    return dinnerList.map((e) {
      return DropdownMenuItem(child: Text(e.name), value: e);
    }).toList();
  }
}
