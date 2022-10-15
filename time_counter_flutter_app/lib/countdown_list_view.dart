import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/time_counter.dart';
import 'package:time_counter_library/time_counter_library.dart';

class _CountdownElement extends StatelessWidget {
  final DateTime _endTime;
  final String _title;
  final int _index;

  const _CountdownElement({
    Key? key,
    required endTime,
    required title,
    required index,
  }) : _endTime = endTime,
        _title = title,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(8),
              child: Text(
                _title.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Text(
              _endTime.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            _CountdownText(goal: _endTime),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => _CountdownView(
                      endTime: _endTime,
                      title: _title,
                    ),
                  )),
                  child: const Text(
                    'See',
                  ),
                ),
                OutlinedButton(
                  onPressed: () => context.read<GoalList>().removeAt(_index),
                  child: const Text(
                    'Remove',
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }
}

class CountdownListView extends StatelessWidget {
  const CountdownListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: context.watch<GoalList>().get().asMap().entries.map((e) {
            return Center(
              child: _CountdownElement(
                endTime: e.value.endTime,
                title: e.value.title,
                index: e.key,
              ),
            );
          }).toList(),
        )
    );
  }
}

class _CountdownText extends StatelessWidget {
  final DateTime _goal;

  const _CountdownText({Key? key, required goal}) : _goal = goal, super(key: key);

  @override
  Widget build(BuildContext context) {
    final TimeCounter _timeCounter = context.watch<TimeCounter>();
    final _remainingTime = RemainingTime(goal: _goal, current: _timeCounter.getDateTime());

    if (_remainingTime.isTimeUp()) {
      return Text(
        RemainingTime.zeroFormat,
        style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.red),
      );
    }
    return Text(
      _remainingTime.getStringFormat(),
      style: Theme.of(context).textTheme.headline4,
    );
  }
}

class _CountdownView extends StatelessWidget {
  final DateTime _endTime;
  final String _title;

  const _CountdownView({
    Key? key,
    required endTime,
    required title,
  }) : _endTime = endTime,
        _title = title,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(8),
              child: Text(
                _title.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Text(
              _endTime.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            _CountdownText(goal: _endTime),
          ],
        ),
      ),
    );
  }

}
