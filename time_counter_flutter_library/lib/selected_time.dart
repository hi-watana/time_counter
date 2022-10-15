library time_counter_flutter_library;

import 'package:flutter/material.dart';

class SelectedTime extends ChangeNotifier {
  static const Duration _lastDateDuration = Duration(days: 50000);

  late DateTime _selectedTime;

  Future<DateTime?> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    return await showDatePicker(context: context, initialDate: _selectedTime, firstDate: now, lastDate: now.add(_lastDateDuration));
  }

  Future<TimeOfDay?> _pickTime(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedTime));
  }

  SelectedTime() {
    final oneHourLater = DateTime.now().add(const Duration(hours: 1));
    _selectedTime = DateTime(oneHourLater.year, oneHourLater.month, oneHourLater.day, oneHourLater.hour);
  }

  void setDate(BuildContext context) async {
    final date = await _pickDate(context);
    if (date != null) {
      _selectedTime = DateTime(date.year, date.month, date.day, _selectedTime.hour, _selectedTime.minute);
    }
    notifyListeners();
  }

  void setTime(BuildContext context) async {
    final time = await _pickTime(context);
    if (time != null) {
      _selectedTime = DateTime(_selectedTime.year, _selectedTime.month, _selectedTime.day, time.hour, time.minute);
    }
    notifyListeners();
  }

  DateTime get() => _selectedTime;
}
