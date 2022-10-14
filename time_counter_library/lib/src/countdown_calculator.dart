class RemainingTime {
  static const String zeroFormat = '0000-00-0-00-00-00';

  late final int _remainingSecond;

  RemainingTime({required goal, required current}) {
    _remainingSecond = _microSecondToSecond(_remainingMicroSecond(goal, current));
  }

  bool isTimeUp() => _remainingSecond < 1;

  String getStringFormat() => _formatRemainingSecond(_remainingSecond);

  int _remainingMicroSecond(DateTime goal, DateTime current) =>
      goal.microsecondsSinceEpoch - current.microsecondsSinceEpoch;

  int _microSecondToSecond(int microSecond) => microSecond ~/ 1000000;

  String _formatRemainingSecond(int remainingSecond) {
    var minutes = remainingSecond ~/ 60;
    remainingSecond %= 60;
    var hours = minutes ~/ 60;
    minutes %= 60;
    var days = hours ~/ 24;
    hours %= 24;
    var weeks = days ~/ 7;
    days %= 7;
    var years = weeks ~/ 52;
    weeks %= 52;
    return '${years.toString().padLeft(4, '0')}-${weeks.toString().padLeft(2, '0')}-${days.toString().padLeft(1, '0')}-${hours.toString().padLeft(2, '0')}-${minutes.toString().padLeft(2, '0')}-${remainingSecond.toString().padLeft(2, '0')}';
  }
}
