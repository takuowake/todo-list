// goal_list_tile.dart
// このファイルは、目標のリストタイルウィジェットを提供します。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/models/goal.dart';
import 'package:goal_list/providers/goal_provider.dart';
import 'package:goal_list/views/edit_goal_screen.dart';

class GoalListTile extends ConsumerWidget {
  final Goal goal;

  GoalListTile({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0), // 各ListTileの上下に余白を追加
      padding: EdgeInsets.symmetric(horizontal: 16.0), // 内側の余白を設定
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // 背景色を透明な白に設定
        borderRadius: BorderRadius.circular(15), // 角を丸める
      ),
      child: ListTile(
        title: Text(
          goal.title,
          style: TextStyle(
            decoration: goal.is_completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('残り: ${_formatRemainingTime(goal.updatedTime)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(goal.is_completed ? Icons.check_box : Icons.check_box_outline_blank),
              onPressed: () {
                ref.watch(goalListProvider.notifier).toggleComplete(goal.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditGoalScreen(goal: goal)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteDialog(context, ref, goal.id);
              },
            ),
          ],
        ),
        onTap: () {
          ref.watch(goalListProvider.notifier).toggleComplete(goal.id);
        },
      ),
    );
  }

  String _formatRemainingTime(DateTime updatedTime) {
    final now = DateTime.now();
    final difference = updatedTime.add(Duration(hours: 24)).difference(now);
    if (difference.isNegative) {
      return "Expired";
    } else {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      return '$hours 時間 $minutes 分';
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String goalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('目標を削除'),
          actions: [
            TextButton(
              onPressed: () {
                ref.watch(goalListProvider.notifier).remove(goalId);
                Navigator.of(context).pop();
              },
              child: const Text('削除する'),
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