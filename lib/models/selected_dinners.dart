import 'package:deans_dinners/models/dinner.dart';
import 'package:flutter/material.dart';

class SelectedDinners extends ChangeNotifier {
  final List<Dinner> selectedDinners = [];

  void add(Dinner dinner) {
    selectedDinners.add(dinner);
    notifyListeners();
  }

  void remove(Dinner dinner) {
    selectedDinners.remove(dinner);
    notifyListeners();
  }

  void removeAll() {
    selectedDinners.clear();
  }
}
