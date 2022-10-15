import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/time_counter.dart';
import 'package:time_counter_library/time_counter_library.dart';

class _CountdownElement extends StatelessWidget {
  final DateTime _endTime;
  final String _description;
  final int _index;

  const _CountdownElement({
    Key? key,
    required endTime,
    required description,
    required index,
  }) : _endTime = endTime,
        _description = description,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(_endTime.toString()),
                subtitle: Text(
                  _description,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _CountdownText(goal: _endTime),
              )
            ],
          ),
        ),
      onDismissed: (direction) {
        context.read<GoalList>().removeAt(_index);
      },
    );
  }
}

class CountdownListView extends StatelessWidget {
  const CountdownListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: context.watch<GoalList>().get().asMap().entries.map((e) {
        return _CountdownElement(
          endTime: e.value.endTime,
          description: e.value.description,
          index: e.key,
        );
      }).toList(),
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
