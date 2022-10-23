import 'package:hive/hive.dart';

import '../time_counter_library.dart';
import 'goal_entity.dart';

const _goalBoxName = 'goalBox';

Future<Box<GoalEntity>> openGoalBox() {
  Hive.registerAdapter(GoalAdapter());
  return Hive.openBox<GoalEntity>(_goalBoxName);
}

GoalEntity _toEntity(GoalView view) => GoalEntity(
  endTime: view.endTime.toUtc(),
  description: view.description,
);

GoalView _toView(GoalEntity entity) => GoalView(
  endTime: entity.endTime.toLocal(),
  description: entity.description,
);

class GoalRepository {
  final Box<GoalEntity> _goalBox;

  GoalRepository(this._goalBox);

  void add(GoalView view) {
    final entity = _toEntity(view);
    _goalBox.add(entity);
  }

  void removeAt(int i) => _goalBox.deleteAt(i);

  void update(int i, GoalView view) {
    final entity = _toEntity(view);
    _goalBox.putAt(i, entity);
  }

  int size() => _goalBox.length;

  List<GoalView> get() => _goalBox.values.map((e) => _toView(e)).toList();
}
