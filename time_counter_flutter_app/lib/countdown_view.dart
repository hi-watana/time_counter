import 'package:flutter/material.dart';
import 'package:time_counter/goal_setter.dart';

class CountdownView extends StatelessWidget {

  const CountdownView({
    Key? key,
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
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            GoalSetter(),
            Padding(padding: EdgeInsets.all(10)),
            //CountdownText(goal: _endTime),
          ],
        ),
      ),
    );
  }

}
