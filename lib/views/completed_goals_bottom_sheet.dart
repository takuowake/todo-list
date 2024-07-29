// completed_goals_bottom_sheet.dart
// このファイルは、完了済みの目標を表示するためのボトムシートウィジェットを提供します。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/providers/goal_provider.dart';

class CompletedGoalsBottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalList = ref.watch(goalListProvider);
    final completedGoals = goalList.where((goal) => goal.isCompleted).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          Text(
            '完了済み目標',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: completedGoals.length,
              itemBuilder: (context, index) {
                final goal = completedGoals[index];
                return ListTile(
                  title: Text(
                    goal.title,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.reply),
                        onPressed: () {
                          _showRestoreDialog(context, ref, goal.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref.watch(goalListProvider.notifier).remove(goal.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref, String goalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('この目標を戻しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                ref.watch(goalListProvider.notifier).toggleComplete(goalId);
                Navigator.of(context).pop();
              },
              child: const Text('はい'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }
}