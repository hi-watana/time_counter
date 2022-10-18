import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_counter/goal_setter.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_library/time_counter_library.dart';

import 'countdown_text.dart';

class CountdownView extends StatelessWidget {
  final Goal? goal;
  final String _heroTag;
  final Null Function(GoalList, Goal) _updateGoalList;

  const CountdownView({
    Key? key,
    this.goal,
    required tag,
    required updateGoalList,
  }) :
        _heroTag = tag,
        _updateGoalList = updateGoalList,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Hero(
        tag: _heroTag,
        child: Card(
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<SelectedTime>(create: (_) => SelectedTime(initialTime: goal?.endTime.toLocal())),
              ChangeNotifierProvider<TextEditingController>(create: (_) => TextEditingController(text: goal?.description)),
              Provider.value(value: _updateGoalList),
            ],
            builder: (context, child) {
              return Container(
                margin: const EdgeInsets.all(20),
                child: const _CountdownElement(),
              );
            },
          ),
        ),
      ),
    );
  }

}

class _CountdownElement extends StatelessWidget {

  const _CountdownElement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _selectedTime = context.watch<SelectedTime>();
    return Column(
      children: <Widget>[
        const GoalEditor(),
        const Padding(padding: EdgeInsets.all(10)),
        Container(
          alignment: AlignmentDirectional.centerEnd,
          child: CountdownText(goal: _selectedTime.get()),
        ),
      ],
    );
  }

}