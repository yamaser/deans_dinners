import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/provider/selected_dinners.dart';
import 'package:deans_dinners/provider/google_sign_in.dart';
import 'package:deans_dinners/screens/dinners_screen.dart';
import 'package:deans_dinners/screens/entries_screen.dart';
import 'package:deans_dinners/screens/add_entry_form_screen.dart';
import 'package:deans_dinners/screens/add_dinner_form_screen.dart';
import 'package:deans_dinners/screens/gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = 'home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List screens = [];

  void addDinnerToList(List<Dinner> selectedDinners, Dinner dinner) {
    selectedDinners.add(dinner);
  }

  void removeDinnerFromList(List<Dinner> selectedDinners, Dinner dinner) {
    selectedDinners.remove(dinner);
  }

  void clearGallery() {
    context.read<SelectedDinners>().clearAll();
  }

  void entriesButtonFunction(BuildContext context) {
    Navigator.of(context).pushNamed(AddEntryFormScreen.routeName);
  }

  void dinnersButtonFunction(BuildContext context) {
    Navigator.of(context).pushNamed(AddDinnerFormScreen.routeName);
  }

  Widget entriesFAB() {
    return FloatingActionButton(
      onPressed: () => entriesButtonFunction(context),
      child: const Icon(Icons.add),
    );
  }

  Widget dinnersFAB() {
    return FloatingActionButton(
      onPressed: () => dinnersButtonFunction(context),
      child: const Icon(Icons.add),
    );
  }

  Widget galleryFAB() {
    return Consumer<SelectedDinners>(
      builder: (context, selectedDinners, child) {
        if (selectedDinners.selectedDinners.isNotEmpty) {
          return FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: clearGallery,
            child: const Icon(Icons.clear_all),
          );
        }
        return Container();
      },
    );
  }

  _HomeState() {
    screens = [
      {
        'screen': const EntriesScreen(),
        'fab': entriesFAB(),
        'navBarItem': entriesNavBarItem(),
        'title': 'Entries',
      },
      {
        'screen': const DinnersScreen(),
        'fab': dinnersFAB(),
        'navBarItem': dinnersNavBarItem(),
        'title': 'Dean\'s Dinners',
      },
      {
        'screen': const GalleryScreen(),
        'fab': galleryFAB(),
        'navBarItem': galleryNavBarItem(),
        'title': 'Select Gallery',
      },
    ];
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          centerTitle: true,
          title: Text(screens[currentIndex]['title']),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                context.read<GoogleSignInProvider>().logout();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => currentIndex = index),
            children: screens.map<Widget>((e) => e['screen']).toList()),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
            items: screens
                .map<BottomNavigationBarItem>((e) => e['navBarItem'])
                .toList()),
        floatingActionButton: screens[currentIndex]['fab']);
  }
}

BottomNavigationBarItem entriesNavBarItem() {
  return const BottomNavigationBarItem(
      icon: Icon(Icons.list_rounded), label: 'Entries');
}

BottomNavigationBarItem dinnersNavBarItem() {
  return const BottomNavigationBarItem(
      icon: Icon(Icons.set_meal), label: 'Dinners');
}

BottomNavigationBarItem galleryNavBarItem() {
  return const BottomNavigationBarItem(
      icon: Icon(Icons.image), label: 'Gallery');
}
