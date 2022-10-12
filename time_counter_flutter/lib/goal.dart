import 'package:hive/hive.dart';
part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal {
  @HiveField(0)
  final DateTime endTime;

  @HiveField(1)
  final String title;

  Goal({
    required this.endTime,
    required this.title,
  });
}