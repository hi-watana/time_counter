import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_flutter_library/time_counter.dart';
import 'package:time_counter_library/time_counter_library.dart';

import 'countdown_list_view.dart';
import 'goal_setter.dart';

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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
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
      body: CountdownListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<SelectedTime>(create: (_) => SelectedTime()),
                  ChangeNotifierProvider<TextEditingController>(create: (_) => TextEditingController()),
                ],
                child: GoalSetter(),
              );
            },
          );
        },
      ),
    );
  }
}
