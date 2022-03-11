import 'package:flutter/material.dart';

class EntryFormScreen extends StatefulWidget {
  const EntryFormScreen({Key? key}) : super(key: key);
  static const routeName = 'entryFormScreen';

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Entry'),
        backgroundColor: Colors.black,
      ),
      body: const Text('Entry Form Screen'),
    );
  }
}
