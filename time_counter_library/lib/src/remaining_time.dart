class RemainingTime {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isTimeUp;

  const RemainingTime._(this.years, this.months, this.days, this.hours, this.minutes, this.seconds, this.isTimeUp);

  static RemainingTime of({required DateTime goal, required DateTime current}) {
    final localGoal = goal.toLocal();
    final localCurrent = current.toLocal();
    final goalTime = DateTime(localGoal.year, localGoal.month, localGoal.day, localGoal.hour, localGoal.minute, localGoal.second);
    final currentTime = DateTime(localCurrent.year, localCurrent.month, localCurrent.day, localCurrent.hour, localCurrent.minute, localCurrent.second);
    final isTimeUp = goalTime.isBefore(currentTime);

    if (isTimeUp) {
      return _of(goalTime, currentTime, isTimeUp);
    }
    return _of(currentTime, goalTime, isTimeUp);
  }

  static RemainingTime _of(DateTime before, DateTime after, bool isTimeUp) {
    final diff = after.difference(before);
    final ds = diff.inSeconds % 60;
    final dm = diff.inMinutes % 60;
    final dh = diff.inHours % 24;
    var day = before.add(Duration(seconds: diff.inSeconds % 86400));
    var dd = 0;
    if (after.day < day.day) {
      dd = 31 - day.day + 1;
      dd = after.day - day.add(Duration(days: dd)).day + dd;
      day = day.add(Duration(days: dd));
    } else {
      dd = after.day - day.day;
    }
    late final int dM;
    late final int dy;
    if (after.month < day.month) {
      dM = DateTime.monthsPerYear + after.month - day.month;
      dy = after.year - day.year - 1;
    } else {
      dM = after.month - day.month;
      dy = after.year - day.year;
    }
    //return '${dy.toString().padLeft(4, '0')}y ${dM.toString().padLeft(2, '0')}M ${dd.toString().padLeft(2, '0')}d ${dh.toString().padLeft(2, '0')}:${dm.toString().padLeft(2, '0')}:${ds.toString().padLeft(2, '0')}';
    return RemainingTime._(dy, dM, dd, dh, dm, ds, isTimeUp);
  }

  String getStringFormat() {
    StringBuffer sb = StringBuffer();
    sb.write(isTimeUp ? '- ' : '+ ');
    if (years > 0) {
      sb.write('${years}y ');
    }
    if (months > 0) {
      sb.write('${months.toString().padLeft(2, '0')}M ');
    }
    if (days > 0) {
      sb.write('${days.toString().padLeft(2, '0')}d ');
    }
    sb.write('${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');
    return sb.toString();
  }
}
