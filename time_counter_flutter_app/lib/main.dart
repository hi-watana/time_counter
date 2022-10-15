import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_library/time_counter_library.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/time_counter.dart';

void main() async {
  await Hive.initFlutter();
  final goalBox = await openGoalBox();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeCounter>(create: (_) => TimeCounter()),
        ChangeNotifierProvider<GoalList>(create: (_) => GoalList(GoalRepository(goalBox))),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Countdown'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SelectedTime>(create: (_) => SelectedTime()),
                ChangeNotifierProvider<TextEditingController>(create: (_) => TextEditingController()),
              ],
              child: GoalSetter(),
            ),
            _CountdownListView(),
          ],
        ),
      ),
    );
  }
}

class GoalSetter extends StatelessWidget {

  const GoalSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DateTimeSetter(),
        _TitleSetter(),
        _GoalSubmitter(),
      ],
    );
  }
}

class _GoalSubmitter extends StatelessWidget {
  const _GoalSubmitter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleController = context.watch<TextEditingController>();

    return OutlinedButton(
      onPressed: _titleController.text.isNotEmpty ? () {
        context.read<GoalList>().add(Goal(
          endTime: context.read<SelectedTime>().get(),
          title: _titleController.text,
        ));
      } : null,
      child: const Text(
        'Add',
      ),
    );
  }
}

class _TitleSetter extends StatelessWidget {

  static const int maxTitleLength = 60;

  const _TitleSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 12),
      child: TextField(
        enabled: true,
        maxLength: maxTitleLength,
        maxLines: 1,
        textAlign: TextAlign.left,
        controller: context.read<TextEditingController>(),
        decoration: const InputDecoration(
          hintText: 'title',
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  static const Duration _lastDateDuration = Duration(days: 50000);

  final SelectedTime _selectedTime;

  const _DateSelector(this._selectedTime, {Key? key}) : super(key: key);

  Future<DateTime?> _pickDate(BuildContext context, DateTime _selectedTime) async {
    final now = DateTime.now();
    return await showDatePicker(context: context, initialDate: _selectedTime, firstDate: now, lastDate: now.add(_lastDateDuration));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        _selectedTime.setDate(await _pickDate(context, _selectedTime.get()));
      },
      child: const Text(
        'Date',
      ),
    );
  }

}

class _TimeSelector extends StatelessWidget {
  final SelectedTime _selectedTime;

  const _TimeSelector(this._selectedTime, {Key? key}) : super(key: key);

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime _selectedTime) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        _selectedTime.setTime(await _pickTime(context, _selectedTime.get()));
      },
      child: const Text(
        'Time',
      ),
    );
  }

}

class _DateTimeSetter extends StatelessWidget {

  const _DateTimeSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _selectedTime = context.watch<SelectedTime>();

    return Row(
      children: [
        _DateSelector(_selectedTime),
        _TimeSelector(_selectedTime),
        Text(_selectedTime.get().toString()),
      ],
    );
  }
}

class CountdownElement extends StatelessWidget {
  final DateTime _endTime;
  final String _title;
  final int _index;

  const CountdownElement({
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

class _CountdownListView extends StatelessWidget {
  const _CountdownListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: context.watch<GoalList>().get().asMap().entries.map((e) {
            return Center(
              child: CountdownElement(
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
