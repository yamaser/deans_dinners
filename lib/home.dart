import 'package:deans_dinners/screens/dinners_screen.dart';
import 'package:deans_dinners/screens/entries_screen.dart';
import 'package:deans_dinners/screens/entry_form_screen.dart';
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

  void entriesButtonFunction(BuildContext context) {
    Navigator.of(context).pushNamed(EntryFormScreen.routeName);
  }

  Widget entriesFAB() {
    return FloatingActionButton(
      onPressed: () => entriesButtonFunction(context),
      child: const Icon(Icons.add),
    );
  }

  Widget dinnersFAB() {
    return FloatingActionButton(
      onPressed: () {},
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
        'navBarItem': entriesNavBarItem()
      },
      {
        'screen': const DinnersScreen(),
        'fab': dinnersFAB(),
        'navBarItem': dinnersNavBarItem()
      },
      {
        'screen': const GalleryScreen(),
        'fab': galleryFAB(),
        'navBarItem': galleryNavBarItem()
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Dean\'s Dinners'),
          backgroundColor: Colors.black,
        ),
        body: screens[currentIndex]['screen'],
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black,
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
