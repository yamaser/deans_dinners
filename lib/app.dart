import 'package:deans_dinners/screens/entry_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:deans_dinners/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(brightness: Brightness.dark),
        routes: {
          Home.routeName: (context) => const Home(),
          EntryFormScreen.routeName: (context) => const EntryFormScreen()
        });
  }
}
