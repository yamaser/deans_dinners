import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deans_dinners/components/date_picker_form_field.dart';
import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/models/entry.dart';
import 'package:deans_dinners/models/screen_arguments.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';

class EditEntryScreen extends StatefulWidget {
  static const routeName = 'EditEntryScreen';

  const EditEntryScreen({Key? key}) : super(key: key);

  @override
  State<EditEntryScreen> createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  final formKey = GlobalKey<FormState>();
  DataRepository repository = DataRepository();

  List<DropdownMenuItem<Dinner>> _buildDropdownMenuItems(
      List<Dinner> dinnerList) {
    return dinnerList.map((e) {
      return DropdownMenuItem(child: Text(e.name), value: e);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    Entry entry = args.entry;
    Dinner dinner = args.dinner;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Entry'),
          toolbarHeight: 40,
          //backgroundColor: Colors.black,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: repository.getDinnersSnapshot(),
          builder: (content, snapshot) {
            if (snapshot.hasData) {
              final List<Dinner> dinnerList =
                  Dinner.buildDinnerListFromSnapshot(snapshot);
              Dinner selectedDinner = dinnerList.firstWhere(
                  (element) => dinner.referenceId == element.referenceId);
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
                            value: selectedDinner,
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
                            value: entry.rating,
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
                            repository.updateEntry(
                                dinner, selectedDinner, entry);
                            dinner = selectedDinner;
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
