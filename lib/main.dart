import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CountDownText()
          ],
        ),
      ),
    );
  }
}

class CountDownText extends StatefulWidget {
  const CountDownText({Key? key}) : super(key: key);

  @override
  State<CountDownText> createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> with SingleTickerProviderStateMixin {
  final DateTime _goal = DateTime(2030, 1, 1);
  late final Ticker _ticker;
  late DateTime _time;

  @override
  void initState() {
    super.initState();
    _time = DateTime.now();
    _ticker = createTicker((elapsed) {
      setState(() {
        _time = DateTime.now();
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatRemainingMicroSecond(_remainingMicroSecond()),
      style: Theme.of(context).textTheme.headline4,
    );
  }

  int _remainingMicroSecond() {
    return _goal.microsecondsSinceEpoch - _time.microsecondsSinceEpoch;
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
