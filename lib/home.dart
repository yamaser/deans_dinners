import 'package:deans_dinners/screens/dinners_screen.dart';
import 'package:deans_dinners/screens/entries_screen.dart';
import 'package:deans_dinners/screens/gallery_screen.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;

  final List screens = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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

Widget entriesFAB() {
  return const FloatingActionButton(
    onPressed: entriesButtonFunction,
    child: Icon(Icons.add),
  );
}

Widget dinnersFAB() {
  return const FloatingActionButton(
    onPressed: dinnersButtonFunction,
    child: Icon(Icons.add),
  );
}

Widget galleryFAB() {
  return const FloatingActionButton(
    onPressed: galleryButtonFunction,
    child: Icon(Icons.add),
  );
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

void entriesButtonFunction() => print('pressed from entries screen');

void dinnersButtonFunction() {}

void galleryButtonFunction() {}
