import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';
import '../controllers/goal_provider.dart';
import '../models/goal_model.dart';

class PastGoalsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastGoals = ref.watch(pastGoalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('過去の目標一覧'),
      ),
      body: GroupedListView<Goal, String>(
        elements: pastGoals,
        groupBy: (goal) => DateFormat('yyyy/MM/dd').format(goal.completionDate ?? goal.updatedTime),
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            groupByValue,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        itemBuilder: (context, Goal goal) {
          return ListTile(
            title: Text(goal.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('作成日: ${DateFormat('yyyy/MM/dd').format(goal.createdTime)}'),
                Text('完了日: ${goal.completionDate != null ? DateFormat('yyyy/MM/dd').format(goal.completionDate!) : '未完了'}'),
              ],
            ),
            trailing: Icon(goal.isCompleted ? Icons.check_circle : Icons.cancel),
          );
        },
        useStickyGroupSeparators: true, // グループセパレータを固定する
        floatingHeader: true, // フローティングヘッダを有効にする
      ),
    );
  }
}