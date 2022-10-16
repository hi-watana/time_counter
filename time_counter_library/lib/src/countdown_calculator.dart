class RemainingTime {
  late final int _remainingSecond;

  RemainingTime({required goal, required current}) {
    _remainingSecond = _remainingMicroSecond(goal, current);
  }

  bool isTimeUp() => _remainingSecond <= 0;

  int _remainingMicroSecond(DateTime goal, DateTime current) {
    return goal.microsecondsSinceEpoch - current.microsecondsSinceEpoch;
  }

  int _microSecondToSecond(int microSecond) => microSecond ~/ 1000000;

  String _formatDifference(int differenceBySecond) {
    var minutes = differenceBySecond ~/ 60;
    differenceBySecond %= 60;
    var hours = minutes ~/ 60;
    minutes %= 60;
    var days = hours ~/ 24;
    hours %= 24;
    var weeks = days ~/ 7;
    days %= 7;
    var years = weeks ~/ 52;
    weeks %= 52;
    return '${years.toString().padLeft(4, '0')}-${weeks.toString().padLeft(2, '0')}-${days.toString().padLeft(1, '0')}-${hours.toString().padLeft(2, '0')}-${minutes.toString().padLeft(2, '0')}-${differenceBySecond.toString().padLeft(2, '0')}';
  }

  String getStringFormat() {
    if (_remainingSecond < 0) {
      return '- ${_formatDifference(-_microSecondToSecond(_remainingSecond) + 1)}';
    }
    return '+ ${_formatDifference(_microSecondToSecond(_remainingSecond))}';
  }
}
