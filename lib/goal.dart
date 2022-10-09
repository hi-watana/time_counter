import 'package:hive/hive.dart';
part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal {
  @HiveField(0)
  final DateTime endTime;

  Goal(this.endTime);
}