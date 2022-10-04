import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
        child: ChangeNotifierProvider<_Goal>(
          create: (context) => _Goal(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const DateTimeSetter(),
              ChangeNotifierProvider<_TimeWrapper>(
                create: (context) => _TimeWrapper(),
                child: const _CountDownList(),
              )
            ],
          ),
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

class _DateTimeSetterState extends State<DateTimeSetter> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _Goal data = Provider.of<_Goal>(context);
    
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
              data.setGoal(year, month, day, hour, minute, second);
            },
            child: const Text(
              'Add',
            )
        ),
      ],
    );
  }

}

class CountDownText extends StatefulWidget {
  const CountDownText({Key? key}) : super(key: key);

  @override
  State<CountDownText> createState() => _CountDownTextState();
}

class _Goal extends ChangeNotifier {
  DateTime _goal = DateTime(2030, 1, 1);

  void setGoal(int year, int month, int day, int hour, int minute, int second) {
    _goal = DateTime(year, month, day, hour, minute, second);
    notifyListeners();
  }

  DateTime getGoal() => _goal;
}

class _TimeWrapper extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();

  void setTime(DateTime dateTime) {
    _dateTime = dateTime;
    notifyListeners();
  }

  DateTime getDateTime() => _dateTime;
}

class _CountDownList extends StatefulWidget {
  const _CountDownList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountDownListState();

}

class _CountDownListState extends State<_CountDownList> with SingleTickerProviderStateMixin {
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
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: const <Widget>[
          Center(
            child: CountDownText(),
          ),
          Center(
            child: CountDownText(),
          ),
        ],
      ),
    );
  }

}

class _CountDownTextState extends State<CountDownText> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final _Goal _goal = Provider.of<_Goal>(context);
    final _TimeWrapper _timeWrapper = Provider.of<_TimeWrapper>(context);
    return Text(
      _formatRemainingMicroSecond(_remainingMicroSecond(_goal.getGoal(), _timeWrapper.getDateTime())),
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
