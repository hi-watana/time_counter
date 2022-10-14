library time_counter_flutter_library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'package:time_counter_library/time_counter_library.dart';

class TimeCounter extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  late final Ticker _ticker;

  TimeCounter() {
    _ticker = Ticker((_) {
      _dateTime = DateTime.now();
      notifyListeners();
    });
    _ticker.start();
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
  }

  DateTime getDateTime() => _dateTime;
}

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

  List<Goal> get() => _goalRepository.get();
}
