import 'package:deans_dinners/models/selected_dinners.dart';
import 'package:deans_dinners/provider/google_sign_in.dart';
import 'package:deans_dinners/screens/add_dinner_form_screen.dart';
import 'package:deans_dinners/screens/add_entry_form_screen.dart';
import 'package:deans_dinners/screens/details_dinner_screen.dart';
import 'package:deans_dinners/screens/details_entry_screen.dart';
import 'package:deans_dinners/screens/edit_dinner_screen.dart';
import 'package:deans_dinners/screens/edit_entry_screen.dart';
import 'package:deans_dinners/screens/image_dinner_screen.dart';
import 'package:deans_dinners/auth.dart';
import 'package:flutter/material.dart';
import 'package:deans_dinners/home.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SelectedDinners>(
            create: (context) => SelectedDinners()),
        ChangeNotifierProvider<GoogleSignInProvider>(
            create: (context) => GoogleSignInProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(brightness: Brightness.light),
          routes: {
            Auth.routeName: ((context) => const Auth()),
            Home.routeName: (context) => const Home(),
            AddEntryFormScreen.routeName: (context) =>
                const AddEntryFormScreen(),
            AddDinnerFormScreen.routeName: (context) =>
                const AddDinnerFormScreen(),
            ImageDinnerScreen.routeName: (context) => const ImageDinnerScreen(),
            DetailsDinnerScreen.routeName: (context) =>
                const DetailsDinnerScreen(),
            EditDinnerScreen.routeName: (context) => const EditDinnerScreen(),
            DetailsEntryScreen.routeName: (context) =>
                const DetailsEntryScreen(),
            EditEntryScreen.routeName: ((context) => const EditEntryScreen()),
          }),
    );
  }
}
