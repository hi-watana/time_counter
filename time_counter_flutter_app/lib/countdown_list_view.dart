import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_counter_flutter_library/goal_list.dart';

import 'countdown_text.dart';

class _CountdownElement extends StatelessWidget {
  final DateTime _endTime;
  final String _description;
  final int _index;

  const _CountdownElement({
    Key? key,
    required endTime,
    required description,
    required index,
  }) : _endTime = endTime,
        _description = description,
        _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsets.only(
            right: 20,
          ),
          child: const Icon(
            Icons.delete,
          ),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(DateFormat.yMMMMEEEEd().add_jm().format(_endTime.toLocal())),
                subtitle: Text(
                  _description,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: CountdownText(goal: _endTime),
              )
            ],
          ),
        ),
      onDismissed: (direction) {
        context.read<GoalList>().removeAt(_index);
      },
    );
  }
}

class CountdownListView extends StatelessWidget {
  const CountdownListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: context.watch<GoalList>().get().asMap().entries.map((e) {
        return _CountdownElement(
          endTime: e.value.endTime,
          description: e.value.description,
          index: e.key,
        );
      }).toList(),
    );
  }
}
