
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/time_counter.dart';
import 'package:time_counter_library/time_counter_library.dart';

class CountdownText extends StatelessWidget {
  final DateTime _goal;

  const CountdownText({Key? key, required goal}) : _goal = goal, super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimeCounter timeCounter = context.watch<TimeCounter>();
    final remainingTime = RemainingTime.of(goal: _goal, current: timeCounter.getDateTime());
    final headline4 = Theme.of(context).textTheme.headline4;
    if (remainingTime.isTimeUp) {
      return Text(
        remainingTime.getStringFormat(),
        style: headline4?.copyWith(color: headline4.color?.withAlpha(60)),
      );
    }
    return Text(
      remainingTime.getStringFormat(),
      style: headline4,
    );
  }
}
