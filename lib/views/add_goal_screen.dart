// add_goal_screen.dart
// このファイルは、新しい目標を追加するためのUIとロジックを提供します。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:goal_list/models/goal.dart';
import 'package:goal_list/providers/goal_provider.dart';
import 'package:goal_list/utils/user_utils.dart';
import 'package:uuid/uuid.dart';

class AddGoalScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          style: Theme.of(context).textTheme.headlineSmall,
          '目標を追加',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // 背景画像を追加
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(labelText: '目標'),
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
                      Fluttertoast.showToast(
                        msg: "「${textController.text}」が追加されました",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      textController.clear();
                    },
                    child: Text('保存する'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}