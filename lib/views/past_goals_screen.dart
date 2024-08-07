import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import '../providers/goal_provider.dart';
import '../models/goal.dart';

class PastGoalsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastGoals = ref.watch(expiredGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('過去の目標一覧'),
      ),
      body: GroupedListView<Goal, String>(
        elements: pastGoals,
        groupBy: (goal) => DateFormat('yyyy/MM/dd').format(goal.completion_date ?? goal.updated_time),
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            groupByValue,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        itemBuilder: (context, Goal goal) {
          return ListTile(
            title: Text(goal.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('作成日: ${DateFormat('yyyy/MM/dd').format(goal.created_time)}'),
                Text('完了日: ${goal.completion_date != null ? DateFormat('yyyy/MM/dd').format(goal.completion_date!) : '未完了'}'),
              ],
            ),
            trailing: Icon(goal.is_completed ? Icons.check_circle : Icons.cancel),
          );
        },
        useStickyGroupSeparators: true,
        floatingHeader: true,
      ),
    );
  }
}