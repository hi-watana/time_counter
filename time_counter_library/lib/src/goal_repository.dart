import 'package:hive/hive.dart';

import '../time_counter_library.dart';

const _goalBoxName = 'goalBox';

Future<Box<Goal>> openGoalBox() {
  Hive.registerAdapter(GoalAdapter());
  return Hive.openBox<Goal>(_goalBoxName);
}

class GoalRepository {
  final Box<Goal> _goalBox;

  GoalRepository(this._goalBox);

  void add(Goal goal) => _goalBox.add(goal);

  void removeAt(int i) => _goalBox.deleteAt(i);

  void update(int i, Goal goal) => _goalBox.putAt(i, goal);

  List<Goal> get() => List.unmodifiable(_goalBox.values);
}
