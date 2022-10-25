import 'package:hive/hive.dart';
part 'goal_entity.g.dart';

@HiveType(typeId: 0)
class GoalEntity {
  @HiveField(0)
  final DateTime endTime;

  @HiveField(1)
  final String description;

  const GoalEntity({
    required this.endTime,
    required this.description,
  });
}