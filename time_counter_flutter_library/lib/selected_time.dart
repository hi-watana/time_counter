library time_counter_flutter_library;

import 'package:flutter/material.dart';

class SelectedTime extends ChangeNotifier {

  late DateTime _selectedTime;

  SelectedTime({
    DateTime? initialTime,
  }) {
    if (initialTime == null) {
      final oneHourLater = DateTime.now().add(const Duration(hours: 1));
      _selectedTime = DateTime(oneHourLater.year, oneHourLater.month, oneHourLater.day, oneHourLater.hour);
    } else {
      _selectedTime = initialTime;
    }
  }

  void setDate(DateTime? date) async {
    if (date != null) {
      _selectedTime = DateTime(date.year, date.month, date.day, _selectedTime.hour, _selectedTime.minute);
      notifyListeners();
    }
  }

  void setTime(TimeOfDay? time) async {
    if (time != null) {
      _selectedTime = DateTime(_selectedTime.year, _selectedTime.month, _selectedTime.day, time.hour, time.minute);
      notifyListeners();
    }
  }

  DateTime get() => _selectedTime;
}
