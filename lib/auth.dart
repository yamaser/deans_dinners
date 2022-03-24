import 'package:deans_dinners/home.dart';
import 'package:deans_dinners/screens/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  static const routeName = '/';
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const Home();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something Went Wrong...'));
          } else {
            return const SignInScreen();
          }
        });
  }
}
