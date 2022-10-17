import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_counter/goal_setter.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_library/time_counter_library.dart';

import 'countdown_text.dart';

class CountdownView extends StatelessWidget {
  final Goal? goal;

  const CountdownView({
    Key? key,
    this.goal,
  }) : super(key: key);

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
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<SelectedTime>(create: (_) => SelectedTime(initialTime: goal?.endTime.toLocal())),
          ChangeNotifierProvider<TextEditingController>(create: (_) => TextEditingController(text: goal?.description)),
        ],
        child: Container(
          margin: const EdgeInsets.all(10),
          child: const _CountdownElement(),
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
        CountdownText(goal: _selectedTime.get()),
      ],
    );
  }

}