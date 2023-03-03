import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_flutter_library/selected_time.dart';
import 'package:time_counter_library/time_counter_library.dart';

import 'constants.dart';

class _DescriptionSetter extends StatelessWidget {

  const _DescriptionSetter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      maxLength: maxDescriptionLength,
      minLines: 1,
      maxLines: 4,
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
    final titleController = context.watch<TextEditingController>();
    final onSubmit = context.read<Null Function(GoalList, GoalView)>();
    final goalList = context.read<GoalList>();

    return OutlinedButton(
      onPressed: titleController.text.isNotEmpty ? () {
        onSubmit(goalList, GoalView(
          endTime: context.read<SelectedTime>().get(),
          description: titleController.text,
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

  Future<DateTime?> _pickDate(BuildContext context, DateTime selectedTime) async {
    final now = DateTime.now();
    return await showDatePicker(
        context: context,
        initialDate:
        selectedTime,
        firstDate:
        now.subtract(_earliestDateDuration),
        lastDate: now.add(_latestDateDuration),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTime = context.watch<SelectedTime>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat.yMMMEd().format(selectedTime.get()),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
          alignment: Alignment.centerRight,
          onPressed: () async {
            selectedTime.setDate(await _pickDate(context, selectedTime.get()));
          }, icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

}

class _TimeSelector extends StatelessWidget {
  static final _timeFormat = DateFormat('hh:mm a');

  const _TimeSelector({Key? key}) : super(key: key);

  Future<TimeOfDay?> _pickTime(BuildContext context, DateTime selectedTime) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(selectedTime));
  }

  @override
  Widget build(BuildContext context) {
    final selectedTime = context.watch<SelectedTime>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _timeFormat.format(selectedTime.get()),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        IconButton(
          alignment: Alignment.centerRight,
          onPressed: () async {
            selectedTime.setTime(await _pickTime(context, selectedTime.get()));
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
