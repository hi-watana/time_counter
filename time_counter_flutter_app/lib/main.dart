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
        ChangeNotifierProvider<SelectedTime>(create: (_) => SelectedTime()),
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
          children: const <Widget>[
            GoalSetter(),
            _CountdownListView(),
          ],
        ),
      ),
    );
  }
}

class GoalSetter extends StatefulWidget {

  const GoalSetter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GoalSetterState();
}

class _DateTimeSetter extends StatelessWidget {

  static const Duration _lastDateDuration = Duration(days: 50000);

  const _DateTimeSetter({Key? key}) : super(key: key);

  Future<DateTime?> _pickDate(BuildContext context, DateTime _selectedTime) async {
    final now = DateTime.now();
    return await showDatePicker(context: context, initialDate: _selectedTime, firstDate: now, lastDate: now.add(_lastDateDuration));
  }

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime _selectedTime) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    final _selectedTime = Provider.of<SelectedTime>(context);

    return Row(
      children: [
        OutlinedButton(
          onPressed: () async {
            _selectedTime.setDate(await _pickDate(context, _selectedTime.get()));
          },
          child: const Text(
            'Date',
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            _selectedTime.setTime(await _pickTime(context, _selectedTime.get()));
          },
          child: const Text(
            'Time',
          ),
        ),
        Text(_selectedTime.get().toString()),
      ],
    );
  }
}

class _GoalSetterState extends State<GoalSetter> {

  static const int maxTitleLength = 60;

  final TextEditingController _titleController = TextEditingController();

  late bool _isAddButtonEnabled;

  @override
  void initState() {
    super.initState();
    _isAddButtonEnabled = _titleController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final GoalList _goalList = Provider.of<GoalList>(context);
    final SelectedTime _selectedTime = Provider.of<SelectedTime>(context);

    return Column(
      children: [
        _DateTimeSetter(),
        Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          child: TextField(
            enabled: true,
            maxLength: maxTitleLength,
            maxLines: 1,
            textAlign: TextAlign.left,
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'title',
            ),
            onChanged: (text) {
              setState(() => _isAddButtonEnabled = text.isNotEmpty);
            },
          ),
        ),
        OutlinedButton(
          onPressed: _isAddButtonEnabled ? () {
            _goalList.add(Goal(
              endTime: _selectedTime.get(),
              title: _titleController.text,
            ));
          } : null,
          child: const Text(
            'Add',
          ),
        ),
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
    final GoalList _goalList = Provider.of<GoalList>(context);
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
                  onPressed: () => _goalList.removeAt(_index),
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
    final GoalList _goalList = Provider.of<GoalList>(context);

    return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: _goalList.get().asMap().entries.map((e) {
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
    final TimeCounter _timeCounter = Provider.of<TimeCounter>(context);
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
