import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_counter/constants.dart';
import 'package:time_counter_flutter_library/goal_list.dart';
import 'package:time_counter_library/time_counter_library.dart';

import 'countdown_text.dart';
import 'countdown_view.dart';

class _CountdownElement extends StatelessWidget {
  final Goal _goal;
  final int _index;

  const _CountdownElement({
    Key? key,
    required goal,
    required index,
  }) : _goal = goal,
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
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => CountdownView(
                goal: _goal,
                tag: '$updateTagPrefix$_index',
                updateGoalList: (GoalList goalList, Goal goal) {
                  goalList.update(_index, goal);
                },
              )),
          );
        },
        child: Hero(
          tag: '$updateTagPrefix$_index',
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: Text(DateFormat.yMMMEd().add_jm().format(_goal.endTime.toLocal())),
                  subtitle: Text(
                    _goal.description,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    right: 20,
                  ),
                  child: CountdownText(goal: _goal.endTime),
                )
              ],
            ),
          ),
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
    final goalList = context.watch<GoalList>();
    return ListView(
      children: goalList.get().asMap().entries.map((e) {
        return _CountdownElement(
          goal: e.value,
          index: e.key,
        );
      }).toList(),
    );
  }
}
