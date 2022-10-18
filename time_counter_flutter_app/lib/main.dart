import 'package:dynamic_color/dynamic_color.dart';
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
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Countdown',
          theme: _lightTheme(lightDynamic),
          darkTheme: _darkTheme(darkDynamic),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: 'Countdown'),
        );
      }
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
      body: const CountdownListView(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            builder: (context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<SelectedTime>(create: (_) => SelectedTime()),
                  ChangeNotifierProvider<TextEditingController>(create: (_) => TextEditingController()),
                ],
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: const GoalSetter(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

ThemeData _lightTheme(ColorScheme? lightColorScheme) {
  final scheme = lightColorScheme ?? ColorScheme.fromSeed(seedColor: const Color(0xFFA4EAA4));
  return ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: scheme,
  );
}

ThemeData _darkTheme(ColorScheme? darkColorScheme) {
  final scheme = darkColorScheme ?? ColorScheme.fromSeed(
    seedColor: const Color(0xFF2D442B),
    brightness: Brightness.dark,
  );
  return ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: scheme,
  );
}