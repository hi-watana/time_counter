import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_counter/constants.dart';
import 'package:time_counter/countdown_view.dart';
import 'package:time_counter_flutter_library/banner_ad_height.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/time_counter.dart';
import 'package:time_counter_library/time_counter_library.dart';

import 'banner_ad.dart';
import 'countdown_list_view.dart';

void main() async {
  await Hive.initFlutter();
  final goalBox = await openGoalBox();
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp
    ],
  );

  MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TimeCounter>(create: (_) => TimeCounter()),
        ChangeNotifierProvider<GoalList>(create: (_) => GoalList(GoalRepository(goalBox))),
        ChangeNotifierProvider<BannerAdHeightHolder>(create: (_) => BannerAdHeightHolder()),
      ],
      builder: (context, child) => const MyApp(),
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
          title: appTitle,
          theme: _lightTheme(lightDynamic),
          darkTheme: _darkTheme(darkDynamic),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: appTitle),
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
    final goalListSize = context.watch<GoalList>().size();
    final bannerAdHeight = context.watch<BannerAdHeightHolder>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: bannerAdHeight.getAdHeight() == null
                ? Container()
                : const CountdownListView(),
          ),
          Hero(
            tag: '$updateTagPrefix$goalListSize',
            child: const SizedBox(
              width: double.infinity,
              child: Card(),
            ),
          ),
          const MyBanner(),
        ],
      ),
      floatingActionButton: bannerAdHeight.getAdHeight() == null ? null : Padding(
        padding: EdgeInsets.only(bottom: bannerAdHeight.getAdHeight()!.toDouble()),
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => CountdownView(
                tag: '$updateTagPrefix$goalListSize',
                updateGoalList: (GoalList goalList, GoalView goal) {
                  goalList.add(goal);
                },
              ),
            ));
          },
        ),
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