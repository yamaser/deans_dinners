import 'package:deans_dinners/models/dinner.dart';
import 'package:deans_dinners/screens/dinners_screen.dart';
import 'package:deans_dinners/screens/entries_screen.dart';
import 'package:deans_dinners/screens/add_entry_form_screen.dart';
import 'package:deans_dinners/screens/add_dinner_form_scree.dart';
import 'package:deans_dinners/screens/gallery_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routeName = '/';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List screens = [];
  List<Dinner> selectedDinnerList = [];

  void addDinnerToList(List<Dinner> selectedDinners, Dinner dinner) {
    selectedDinners.add(dinner);
  }

  void removeDinnerFromList(List<Dinner> selectedDinners, Dinner dinner) {
    selectedDinners.remove(dinner);
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
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add),
    );
  }

  _HomeState() {
    screens = [
      {
        'screen': EntriesScreen(),
        'fab': entriesFAB(),
        'navBarItem': entriesNavBarItem(),
        'title': 'Entries',
      },
      {
        'screen': DinnersScreen(),
        'fab': dinnersFAB(),
        'navBarItem': dinnersNavBarItem(),
        'title': 'Dean\'s Dinners',
      },
      {
        'screen': GalleryScreen(),
        'fab': galleryFAB(),
        'navBarItem': galleryNavBarItem(),
        'title': 'Select Gallery',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          centerTitle: true,
          title: Text(screens[currentIndex]['title']),
          //backgroundColor: Colors.black,
        ),
        body: IndexedStack(
            index: currentIndex,
            children: screens.map<Widget>((e) => e['screen']).toList()),
        //screens[currentIndex]['screen'],
        bottomNavigationBar: BottomNavigationBar(
            //backgroundColor: Colors.black,
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
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
