import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_library/time_counter_library.dart';

class _DescriptionSetter extends StatelessWidget {

  static const int maxTitleLength = 60;

  const _DescriptionSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      maxLength: maxTitleLength,
      maxLines: 1,
      textAlign: TextAlign.left,
      controller: context.read<TextEditingController>(),
      decoration: const InputDecoration(
        labelText: 'description',
      ),
    );
  }
}

class _GoalSubmitter extends StatelessWidget {
  const _GoalSubmitter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _titleController = context.watch<TextEditingController>();
    final _onSubmit = context.read<Null Function(GoalList, Goal)>();
    final _goalList = context.read<GoalList>();

    return OutlinedButton(
      onPressed: _titleController.text.isNotEmpty ? () {
        _onSubmit(_goalList, Goal(
          endTime: context.read<SelectedTime>().get().toUtc(),
          description: _titleController.text,
        ));
        Navigator.pop(context);
      } : null,
      child: const Text(
        'Save',
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  static const Duration _latestDateDuration = Duration(days: 50000);
  static const Duration _earliestDateDuration = Duration(days: 50000);

  const _DateSelector({Key? key}) : super(key: key);

  Future<DateTime?> _pickDate(BuildContext context, DateTime _selectedTime) async {
    final now = DateTime.now();
    return await showDatePicker(
        context: context,
        initialDate:
        _selectedTime,
        firstDate:
        now.subtract(_earliestDateDuration),
        lastDate: now.add(_latestDateDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _selectedTime = context.watch<SelectedTime>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMEd().format(_selectedTime.get()),
          style: Theme.of(context).textTheme.bodyLarge,
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
  static final _timeFormat = DateFormat('hh:mm a');

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
          _timeFormat.format(_selectedTime.get()),
          style: Theme.of(context).textTheme.bodyLarge,
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

class GoalEditor extends StatelessWidget {

  const GoalEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DateSelector(),
        const _TimeSelector(),
        const _DescriptionSetter(),
        Container(
          alignment: Alignment.centerRight,
          child: const _GoalSubmitter(),
        )
      ],
    );
  }
}
