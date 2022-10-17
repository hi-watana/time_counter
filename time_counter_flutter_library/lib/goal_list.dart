library time_counter_flutter_library;

import 'package:flutter/foundation.dart';

import 'package:time_counter_library/time_counter_library.dart';

class GoalList extends ChangeNotifier {
  final GoalRepository _goalRepository;

  GoalList(this._goalRepository);

  void add(Goal goal) {
    _goalRepository.add(goal);
    notifyListeners();
  }

  void removeAt(int i) {
    _goalRepository.removeAt(i);
    notifyListeners();
  }

  void update(int i, Goal goal) {
    _goalRepository.update(i, goal);
    notifyListeners();
  }

  List<Goal> get() => _goalRepository.get();
}
