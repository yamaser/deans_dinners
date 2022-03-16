import 'package:deans_dinners/screens/add_dinner_form_scree.dart';
import 'package:deans_dinners/screens/add_entry_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:deans_dinners/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(brightness: Brightness.light),
        routes: {
          Home.routeName: (context) => const Home(),
          AddEntryFormScreen.routeName: (context) => const AddEntryFormScreen(),
          AddDinnerFormScreen.routeName: (context) =>
              const AddDinnerFormScreen(),
        });
  }
}
