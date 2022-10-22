import 'package:test/test.dart';
import 'package:time_counter_library/time_counter_library.dart';
import 'package:tuple/tuple.dart';

class _TestRemainingTime {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isTimeUp;

  @override
  bool operator ==(Object other) {
    return other is _TestRemainingTime &&
        years == other.years &&
        months == other.months &&
        days == other.days &&
        hours == other.hours &&
        minutes == other.minutes &&
        seconds == other.seconds &&
        isTimeUp == other.isTimeUp;
  }

  @override
  int get hashCode => Object.hash(
    years,
    months,
    days,
    hours,
    minutes,
    seconds,
    isTimeUp,
  );

  @override
  String toString() => '$years $months $days $hours $minutes $seconds $isTimeUp';

  const _TestRemainingTime(this.years, this.months, this.days, this.hours, this.minutes, this.seconds, this.isTimeUp);
}

class _TestCase {
  final String testLabel;
  late final DateTime goal;
  late final DateTime current;
  late final _TestRemainingTime expected;

  _TestCase(this.testLabel, String goal, String current, int years, int months, int days, int hours, int minutes, int seconds, bool isTimeUp) {
    this.goal = DateTime.parse(goal);
    this.current = DateTime.parse(current);
    expected = _TestRemainingTime(years, months, days, hours, minutes, seconds, isTimeUp);
  }
}

void main() {
  group('RemainingTime', () {
    group('of should generate RemainingTime correctly', () {
      final testCases = [
        // label, goal, current, years, months, days, hours, minutes, seconds, isTimeUp
        _TestCase('01', '2001-01-01 00:00:00', '2001-01-01 00:00:00', 0, 0, 0, 0, 0, 0, false),
        _TestCase('02', '2001-01-01 00:00:10', '2001-01-01 00:00:00', 0, 0, 0, 0, 0, 10, false),
        _TestCase('03', '2001-01-01 00:00:00', '2001-01-01 00:00:10', 0, 0, 0, 0, 0, 10, true),
        _TestCase('04', '2001-01-01 00:01:00', '2001-01-01 00:00:10', 0, 0, 0, 0, 0, 50, false),
        _TestCase('05', '2001-01-01 00:01:20', '2001-01-01 00:02:10', 0, 0, 0, 0, 0, 50, true),
        _TestCase('06', '2001-01-01 01:01:20', '2001-01-01 00:02:30', 0, 0, 0, 0, 58, 50, false),
        _TestCase('07', '2001-01-01 01:01:20', '2001-01-01 02:00:05', 0, 0, 0, 0, 58, 45, true),
        _TestCase('08', '2001-01-03 01:01:20', '2001-01-01 02:00:05', 0, 0, 1, 23, 1, 15, false),
        _TestCase('09', '2001-01-01 01:01:20', '2001-01-02 00:02:30', 0, 0, 0, 23, 1, 10, true),
        _TestCase('10', '2001-02-21 00:00:00', '2001-02-01 00:00:00', 0, 0, 20, 0, 0, 0, false),
        _TestCase('11', '2001-02-21 00:00:00', '2001-01-03 00:00:00', 0, 1, 18, 0, 0, 0, false),
        _TestCase('12', '2001-01-21 00:00:00', '2001-02-03 00:00:00', 0, 0, 13, 0, 0, 0, true),
        _TestCase('13', '2001-03-21 00:00:00', '2001-02-03 00:00:00', 0, 1, 18, 0, 0, 0, false),
        _TestCase('14', '2001-02-21 00:00:00', '2001-03-03 00:00:00', 0, 0, 10, 0, 0, 0, true),
        _TestCase('15', '2000-02-21 00:00:00', '2000-03-03 00:00:00', 0, 0, 11, 0, 0, 0, true),
        _TestCase('16', '2001-03-21 00:00:00', '2001-05-03 00:00:00', 0, 1, 13, 0, 0, 0, true),
        _TestCase('17', '2001-04-21 00:00:00', '2001-07-03 00:00:00', 0, 2, 12, 0, 0, 0, true),
        _TestCase('18', '2001-07-21 00:00:00', '2001-05-06 00:00:00', 0, 2, 15, 0, 0, 0, false),
        _TestCase('19', '2001-05-21 00:00:00', '2001-07-06 00:00:00', 0, 1, 16, 0, 0, 0, true),
        _TestCase('20', '2001-06-21 00:00:00', '2001-07-06 00:00:00', 0, 0, 15, 0, 0, 0, true),
        _TestCase('21', '2001-08-01 00:00:00', '2001-07-06 00:00:00', 0, 0, 26, 0, 0, 0, false),
        _TestCase('22', '2001-09-01 00:00:00', '2001-08-06 00:00:00', 0, 0, 26, 0, 0, 0, false),
        _TestCase('23', '2001-10-01 00:00:00', '2001-09-06 00:00:00', 0, 0, 25, 0, 0, 0, false),
        _TestCase('24', '2001-11-01 00:00:00', '2001-10-06 00:00:00', 0, 0, 26, 0, 0, 0, false),
        _TestCase('25', '2001-12-01 00:00:00', '2001-11-06 00:00:00', 0, 0, 25, 0, 0, 0, false),
        _TestCase('26', '2002-01-01 00:00:00', '2001-12-06 00:00:00', 0, 0, 26, 0, 0, 0, false),
        _TestCase('27', '2003-05-01 00:00:00', '2001-04-06 00:00:00', 2, 0, 25, 0, 0, 0, false),
        _TestCase('28', '2003-05-01 00:00:00', '2001-08-06 00:00:00', 1, 8, 26, 0, 0, 0, false),

        _TestCase('29', '2001-02-28 00:00:00', '2000-02-28 00:00:00', 1, 0, 0, 0, 0, 0, false),
        _TestCase('30', '2001-02-28 00:00:00', '2000-02-28 06:00:00', 0, 11, 28, 18, 0, 0, false),
        _TestCase('31', '2001-02-28 00:00:00', '2000-02-29 00:00:00', 0, 11, 28, 0, 0, 0, false),
        _TestCase('32', '2001-03-01 00:00:00', '2000-03-01 00:00:00', 1, 0, 0, 0, 0, 0, false),

        _TestCase('33', '2008-02-29 00:00:00', '2001-02-28 00:00:00', 7, 0, 1, 0, 0, 0, false),
        _TestCase('34', '2008-02-29 00:00:00', '2001-02-28 10:00:00', 6, 11, 28, 14, 0, 0, false),
        _TestCase('35', '2008-02-29 00:00:00', '2001-03-01 00:00:00', 6, 11, 28, 0, 0, 0, false),
      ];

      for (var testCase in testCases) {
        test('${testCase.testLabel}: ${testCase.goal} - ${testCase.current}', () {
          final diff = RemainingTime.of(goal: testCase.goal, current: testCase.current);
          final actual = _TestRemainingTime(diff.years, diff.months, diff.days, diff.hours, diff.minutes, diff.seconds, diff.isTimeUp);
          expect(actual, testCase.expected);
        });
      }
    });

    group('toString should return string format correctly', () {
      final base01Jan = DateTime(2001);
      final base01Feb = DateTime(2001, 2);
      final base02Jan = DateTime(2002, 2);
      final base02Feb = DateTime(2002, 2);
      // label, goal, current, expected
      final testCases = [
        Tuple4('01', base01Jan, base01Jan, '+ 00:00:00'),
        Tuple4('02', base01Jan.add(Duration(seconds: 3)), base01Jan, '+ 00:00:03'),
        Tuple4('03', base01Jan.add(Duration(seconds: 10)), base01Jan, '+ 00:00:10'),
        Tuple4('04', base01Jan.add(Duration(minutes: 1)), base01Jan, '+ 00:01:00'),
        Tuple4('05', base01Jan.add(Duration(minutes: 12, seconds: 3)), base01Jan, '+ 00:12:03'),
        Tuple4('06', base01Jan.add(Duration(hours: 2)), base01Jan, '+ 02:00:00'),
        Tuple4('07', base01Jan.add(Duration(hours: 2, seconds: 30)), base01Jan, '+ 02:00:30'),
        Tuple4('08', base01Jan.add(Duration(hours: 20, minutes: 25)), base01Jan, '+ 20:25:00'),
        Tuple4('09', base01Jan.add(Duration(hours: 20, minutes: 2, seconds: 3)), base01Jan, '+ 20:02:03'),
        Tuple4('10', base01Jan.add(Duration(days: 1)), base01Jan, '+ 01d 00:00:00'),
        Tuple4('11', base01Feb, base01Jan, '+ 01M 00d 00:00:00'),
        Tuple4('12', base01Feb.add(Duration(days: 20)), base01Jan, '+ 01M 20d 00:00:00'),
        Tuple4('13', base02Jan, base01Jan, '+ 01y 00M 00d 00:00:00'),
        Tuple4('14', base02Jan.add(Duration(days: 1)), base01Jan, '+ 01d 00M 01d 00:00:00'),
        Tuple4('15', base02Feb, base01Jan, '+ 1y 01M 00d 00:00:00'),
        Tuple4('16', base02Feb.add(Duration(days: 20)), base01Jan, '+ 1y 01M 20d 00:00:00'),

        Tuple4('17', base01Jan, base01Jan.add(Duration(seconds: 3)), '- 00:00:03'),
        Tuple4('18', base01Jan, base01Jan.add(Duration(seconds: 10)), '- 00:00:10'),
        Tuple4('19', base01Jan, base01Jan.add(Duration(minutes: 1)), '- 00:01:00'),
        Tuple4('20', base01Jan, base01Jan.add(Duration(minutes: 12, seconds: 3)), '- 00:12:03'),
        Tuple4('21', base01Jan, base01Jan.add(Duration(hours: 2)), '- 02:00:00'),
        Tuple4('22', base01Jan, base01Jan.add(Duration(hours: 2, seconds: 30)), '- 02:00:30'),
        Tuple4('23', base01Jan, base01Jan.add(Duration(hours: 20, minutes: 25)), '- 20:25:00'),
        Tuple4('24', base01Jan, base01Jan.add(Duration(hours: 20, minutes: 2, seconds: 3)), '- 20:02:03'),
        Tuple4('25', base01Jan, base01Jan.add(Duration(days: 1)), '- 01d 00:00:00'),
        Tuple4('26', base01Feb, base01Jan, '- 01M 00d 00:00:00'),
        Tuple4('27', base01Jan, base01Feb.add(Duration(days: 20)), '- 01M 20d 00:00:00'),
        Tuple4('28', base01Jan, base02Jan, '- 01y 00M 00d 00:00:00'),
        Tuple4('29', base01Jan, base02Jan.add(Duration(days: 1)), '- 01d 00M 01d 00:00:00'),
        Tuple4('30', base01Jan, base02Feb, '- 1y 01M 00d 00:00:00'),
        Tuple4('31', base01Jan, base02Feb.add(Duration(days: 20)), '- 1y 01M 20d 00:00:00'),
      ];

      for (var testCase in testCases) {
        final String label = testCase.item1;
        final DateTime goal = testCase.item2;
        final DateTime current = testCase.item3;
        final String expected = testCase.item4;
        test('$label: $expected', () {
          final diff = RemainingTime.of(goal: goal, current: current);
          expect(diff.toString(), expected);
        });
      }
    });
  });
}
