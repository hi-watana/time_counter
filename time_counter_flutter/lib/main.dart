import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:time_counter_infra/time_counter_infra.dart';

const goalBoxName = 'goalBox';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GoalAdapter());
  await Hive.openBox<Goal>(goalBoxName);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<_TimeCounter>(create: (_) => _TimeCounter()),
        ChangeNotifierProvider<_GoalList>(create: (_) => _GoalList()),
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
            DateTimeSetter(),
            _CountdownListView(),
          ],
        ),
      ),
    );
  }
}

class DateTimeSetter extends StatefulWidget {

  const DateTimeSetter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateTimeSetterState();
}

class _DateTimeSetterState extends State<DateTimeSetter> {

  static const int maxTitleLength = 60;

  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();

  late bool _isAddButtonEnabled;

  @override
  void initState() {
    super.initState();
    _isAddButtonEnabled = _titleController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final _GoalList _goalList = Provider.of<_GoalList>(context);

    return Column(
      children: [
        Row(
          children: [
            _PaddedTextField(
              maxLength: 4,
              hintText: 'yyyy',
              controller: _yearController,
            ),
            _PaddedTextField(
              maxLength: 2,
              hintText: 'MM',
              controller: _monthController,
            ),
            _PaddedTextField(
              maxLength: 2,
              hintText: 'dd',
              controller: _dayController,
            ),
          ],
        ),
        Row(
          children: [
            _PaddedTextField(
              maxLength: 2,
              hintText: 'hh',
              controller: _hourController,
            ),
            _PaddedTextField(
              maxLength: 2,
              hintText: 'mm',
              controller: _minuteController,
            ),
            _PaddedTextField(
              maxLength: 2,
              hintText: 'ss',
              controller: _secondController,
            ),
          ],
        ),
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
              setState(() {
                _isAddButtonEnabled = text.isNotEmpty;
              });
            },
          ),
        ),
        OutlinedButton(
          onPressed: _isAddButtonEnabled ? () {
            final int year = int.parse(_yearController.text);
            final int month = int.parse(_monthController.text);
            final int day = int.parse(_dayController.text);
            final int hour = int.parse(_hourController.text);
            final int minute = int.parse(_minuteController.text);
            final int second = int.parse(_secondController.text);
            _goalList.add(Goal(
              endTime: DateTime(year, month, day, hour, minute, second),
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

class _PaddedTextField extends StatelessWidget {

  final int _maxLength;
  final String _hintText;
  final TextEditingController _controller;

  const _PaddedTextField({
    Key? key,
    required maxLength,
    required hintText,
    required controller,
  }) : _maxLength = maxLength,
        _hintText = hintText,
        _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: TextField(
          enabled: true,
          maxLength: _maxLength,
          maxLines: 1,
          textAlign: TextAlign.right,
          controller: _controller,
          decoration: InputDecoration(
            hintText: _hintText,
          ),
        ),
      ),
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
    final _GoalList _goalList = Provider.of<_GoalList>(context);
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

class _TimeCounter extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  late final Ticker _ticker;

  _TimeCounter() {
     _ticker = Ticker((_) {
       _dateTime = DateTime.now();
       notifyListeners();
     });
     _ticker.start();
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
  }

  DateTime getDateTime() => _dateTime;
}

class _GoalList extends ChangeNotifier {
  final _goalBox = Hive.box<Goal>(goalBoxName);

  void add(Goal goal) {
    _goalBox.add(goal);
    notifyListeners();
  }

  void removeAt(int i) {
    _goalBox.deleteAt(i);
    notifyListeners();
  }

  List<Goal> get() => List.unmodifiable(_goalBox.values);
}

class _CountdownListView extends StatelessWidget {
  const _CountdownListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _GoalList _goalList = Provider.of<_GoalList>(context);

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
    final _TimeCounter _timeCounter = Provider.of<_TimeCounter>(context);
    final int _remaining = _microSecondToSecond(_remainingMicroSecond(_goal, _timeCounter.getDateTime()));

    if (_remaining < 1) {
      return Text(
        _formatRemainingSecond(0),
        style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.red),
      );
    }
    return Text(
      _formatRemainingSecond(_remaining),
      style: Theme.of(context).textTheme.headline4,
    );
  }

  int _remainingMicroSecond(DateTime _goal, DateTime _current) => _goal.microsecondsSinceEpoch - _current.microsecondsSinceEpoch;

  int _microSecondToSecond(int microSecond) => microSecond ~/ 1000000;

  String _formatRemainingSecond(int remainingSecond) {
    var minutes = remainingSecond ~/ 60;
    remainingSecond %= 60;
    var hours = minutes ~/ 60;
    minutes %= 60;
    var days = hours ~/ 24;
    hours %= 24;
    var weeks = days ~/ 7;
    days %= 7;
    var years = weeks ~/ 52;
    weeks %= 52;
    return years.toString().padLeft(4, '0') + '-'
        + weeks.toString().padLeft(2, '0') + '-'
        + days.toString().padLeft(1, '0') + '-'
        + hours.toString().padLeft(2, '0') + '-'
        + minutes.toString().padLeft(2, '0') + '-'
        + remainingSecond.toString().padLeft(2, '0');
  }
}