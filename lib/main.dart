import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<_TimeWrapper>(
        create: (context) => _TimeWrapper(),
        child: const MyApp()
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  _TimeWrapper? _timeWrapper;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_timeWrapper == null) {
      _timeWrapper = Provider.of<_TimeWrapper>(context);
      _ticker = createTicker((elapsed) {
        _timeWrapper!.setTime(DateTime.now());
      });
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

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
        child: ChangeNotifierProvider<_DateTimeList>(
          create: (context) => _DateTimeList(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DateTimeSetter(),
              const _CountdownListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeSetter extends StatelessWidget {

  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  DateTimeSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _DateTimeList _countDownList = Provider.of<_DateTimeList>(context);

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
        OutlinedButton(
            onPressed: () {
              final int year = int.parse(_yearController.text);
              final int month = int.parse(_monthController.text);
              final int day = int.parse(_dayController.text);
              final int hour = int.parse(_hourController.text);
              final int minute = int.parse(_minuteController.text);
              final int second = int.parse(_secondController.text);
              _countDownList.add(DateTime(year, month, day, hour, minute, second));
            },
            child: const Text(
              'Add',
            )
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
  final DateTime _goal;
  final int _index;

  const CountdownElement({
    Key? key,
    required goal,
    required index,
  }) : _goal = goal,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _DateTimeList _dateTimeList = Provider.of<_DateTimeList>(context);
    return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text(
              _goal.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            _CountdownText(goal: _goal),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                OutlinedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => _CountdownView(goal: _goal),
                  )),
                  child: const Text(
                    'See',
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _dateTimeList.removeAt(_index),
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

class _TimeWrapper extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();

  void setTime(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }

  DateTime getDateTime() => _dateTime;
}

class _DateTimeList extends ChangeNotifier {
  final List<DateTime> _list = [];

  void add(DateTime dateTime) {
    _list.add(dateTime);
    notifyListeners();
  }

  void removeAt(int i) {
    _list.removeAt(i);
    notifyListeners();
  }

  List<DateTime> get() => List.unmodifiable(_list);
}

class _CountdownListView extends StatelessWidget {
  const _CountdownListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _DateTimeList _dateTimeList = Provider.of<_DateTimeList>(context);

    return Expanded(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: _dateTimeList.get().asMap().entries.map((e) {
            return Center(
              child: CountdownElement(
                goal: e.value,
                index: e.key,
              ),
            );
          }).toList(),
        )
    );
  }
}

class _CountdownView extends StatelessWidget {
  final DateTime _goal;

  const _CountdownView({Key? key, required goal}) : _goal = goal, super(key: key);

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
            Text(
              _goal.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
            _CountdownText(goal: _goal),
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
    final _TimeWrapper _timeWrapper = Provider.of<_TimeWrapper>(context);
    return Text(
      _formatRemainingMicroSecond(_remainingMicroSecond(_goal, _timeWrapper.getDateTime())),
      style: Theme.of(context).textTheme.headline4,
    );
  }

  int _remainingMicroSecond(DateTime _goal, DateTime _current) {
    return _goal.microsecondsSinceEpoch - _current.microsecondsSinceEpoch;
  }

  String _formatRemainingMicroSecond(int remainingMicroSecond) {
    var seconds = remainingMicroSecond ~/ 1000000;
    var minutes = seconds ~/ 60;
    seconds %= 60;
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
        + seconds.toString().padLeft(2, '0');
  }
}