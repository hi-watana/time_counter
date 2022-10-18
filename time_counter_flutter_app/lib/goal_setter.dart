import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_library/time_counter_library.dart';

class _TitleSetter extends StatelessWidget {

  static const int maxTitleLength = 60;

  const _TitleSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      maxLength: maxTitleLength,
      maxLines: 1,
      textAlign: TextAlign.left,
      controller: context.read<TextEditingController>(),
      decoration: const InputDecoration(
        hintText: 'title',
      ),
    );
  }
}

class _GoalSubmitter extends StatelessWidget {
  const _GoalSubmitter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleController = context.watch<TextEditingController>();

    return OutlinedButton(
      onPressed: _titleController.text.isNotEmpty ? () {
        context.read<GoalList>().add(Goal(
          endTime: context.read<SelectedTime>().get().toUtc(),
          description: _titleController.text,
        ));
        Navigator.pop(context);
      } : null,
      child: const Text(
        'Add',
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  static const Duration _lastDateDuration = Duration(days: 50000);

  const _DateSelector({Key? key}) : super(key: key);

  Future<DateTime?> _pickDate(BuildContext context, DateTime _selectedTime) async {
    final now = DateTime.now();
    return await showDatePicker(context: context, initialDate: _selectedTime, firstDate: now, lastDate: now.add(_lastDateDuration));
  }

  @override
  Widget build(BuildContext context) {
    final _selectedTime = context.watch<SelectedTime>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMMEEEEd().format(_selectedTime.get()),
        ),
        IconButton(
          alignment: Alignment.centerRight,
          onPressed: () async {
            _selectedTime.setDate(await _pickDate(context, _selectedTime.get()));
          }, icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

}

class _TimeSelector extends StatelessWidget {
  const _TimeSelector({Key? key}) : super(key: key);

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime _selectedTime) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    final _selectedTime = context.watch<SelectedTime>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.Hm().format(_selectedTime.get()),
        ),
        IconButton(
          alignment: Alignment.centerRight,
          onPressed: () async {
            _selectedTime.setTime(await _pickTime(context, _selectedTime.get()));
          }, icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

}

class GoalSetter extends StatelessWidget {

  const GoalSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DateSelector(),
        const _TimeSelector(),
        const _TitleSetter(),
        Container(
          alignment: Alignment.centerRight,
          child: const _GoalSubmitter(),
        )
      ],
    );
  }
}
