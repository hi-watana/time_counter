library time_counter_flutter_library;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class TimeCounter extends ChangeNotifier {
  DateTime _dateTime = DateTime.now();
  late final Ticker _ticker;

  TimeCounter() {
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