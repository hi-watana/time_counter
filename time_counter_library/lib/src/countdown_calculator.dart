class RemainingTime {
  late final DateTime _goal;
  late final DateTime _current;

  RemainingTime({required goal, required current}) {
    final localGoal = goal.toUtc();
    final localCurrent = current.toUtc();
    _goal = DateTime(localGoal.year, localGoal.month, localGoal.day, localGoal.hour, localGoal.minute, localGoal.second);
    _current = DateTime(localCurrent.year, localCurrent.month, localCurrent.day, localCurrent.hour, localCurrent.minute, localCurrent.second);
  }

  bool isTimeUp() => _goal.isBefore(_current);

  String _formatDifference(DateTime before, DateTime after) {
    final diff = after.difference(before);
    final ds = diff.inSeconds % 60;
    final dm = diff.inMinutes % 60;
    final dh = diff.inHours % 24;
    var day = before.add(Duration(seconds: diff.inSeconds % 86400));
    var dd = 0;
    if (after.day < day.day) {
      dd = 31 - day.day + 1;
      dd = after.day - day.add(Duration(days: dd)).day + dd;
    } else {
      dd = after.day - day.day;
    }
    day = day.add(Duration(days: dd));
    late final int dM;
    late final int dy;
    if (after.month < day.month) {
      dM = DateTime.monthsPerYear + after.month - day.month;
      dy = after.year - day.year - 1;
    } else {
      dM = after.month - day.month;
      dy = after.year - day.year;
    }
    return '${dy.toString().padLeft(4, '0')}y ${dM.toString().padLeft(2, '0')}M ${dd.toString().padLeft(2, '0')}d ${dh.toString().padLeft(2, '0')}:${dm.toString().padLeft(2, '0')}:${ds.toString().padLeft(2, '0')}';
  }

  String getStringFormat() {
    if (isTimeUp()) {
      return '- ${_formatDifference(_goal, _current)}';
    }
    return '+ ${_formatDifference(_current, _goal)}';
  }
}
