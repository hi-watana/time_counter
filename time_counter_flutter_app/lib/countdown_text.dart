
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/time_counter.dart';
import 'package:time_counter_library/time_counter_library.dart';

class CountdownText extends StatelessWidget {
  final DateTime _goal;

  const CountdownText({Key? key, required goal}) : _goal = goal, super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimeCounter _timeCounter = context.watch<TimeCounter>();
    final _remainingTime = RemainingTime.of(goal: _goal, current: _timeCounter.getDateTime());
    final _headline4 = Theme.of(context).textTheme.headline4;
    if (_remainingTime.isTimeUp) {
      return Text(
        _remainingTime.getStringFormat(),
        style: _headline4?.copyWith(color: _headline4.color?.withAlpha(60)),
      );
    }
    return Text(
      _remainingTime.getStringFormat(),
      style: _headline4,
    );
  }
}
