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
    selectedDinners
        .removeWhere((item) => item.referenceId == dinner.referenceId);
    notifyListeners();
  }

  bool containsDinnerRef(Dinner dinner) {
    return selectedDinners
        .map((e) => e.referenceId)
        .toList()
        .contains(dinner.referenceId);
  }

  void update(Dinner dinner) {
    selectedDinners.remove(dinner);
    selectedDinners.add(dinner);
    notifyListeners();
  }

  void clearAll() {
    selectedDinners.clear();
    notifyListeners();
  }
}
