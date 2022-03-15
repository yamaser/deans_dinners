import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/repository/data_repository.dart';
import 'package:flutter/material.dart';

class AddDinnerFormScreen extends StatefulWidget {
  static const routeName = 'AddDinnerFormScreen';

  const AddDinnerFormScreen({Key? key}) : super(key: key);

  @override
  State<AddDinnerFormScreen> createState() => _AddDinnerFormScreenState();
}

class _AddDinnerFormScreenState extends State<AddDinnerFormScreen> {
  final formKey = GlobalKey<FormState>();
  DataRepository repository = DataRepository();
  Dinner dinner = Dinner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create New Dinner Item'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a name' : null,
                      onSaved: (value) {
                        dinner.name = value.toString();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) {
                        if (value!.isNotEmpty) {
                          dinner.description = value.toString();
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          repository.addDinner(dinner);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Submit')),
                ],
              )),
        ));
  }
}
