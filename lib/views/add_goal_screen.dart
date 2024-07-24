// add_goal_screen.dart
// 新しい目標を追加する画面。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/models/goal.dart';
import 'package:goal_list/providers/goal_provider.dart';
import 'package:goal_list/utils/user_utils.dart';
import 'package:uuid/uuid.dart';

class AddGoalScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('目標を追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(labelText: '目標'),
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final userId = await UserUtils.getUserId();
                final newGoal = Goal(
                  id: Uuid().v4(),
                  userId: userId,
                  title: textController.text,
                  createdTime: DateTime.now(),
                  updatedTime: DateTime.now(),
                );
                ref.read(goalListProvider.notifier).add(newGoal);
                Navigator.of(context).pop();
              },
              child: Text('保存する'),
            ),
          ],
        ),
      ),
    );
  }
}