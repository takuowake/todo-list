// edit_goal_screen.dart
// このファイルは、既存の目標を編集するためのUIとロジックを提供します。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/models/goal.dart';
import 'package:goal_list/providers/goal_provider.dart';

class EditGoalScreen extends ConsumerWidget {
  final Goal goal;

  EditGoalScreen({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController(text: goal.title);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('目標を編集'),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                    ),
                    onPressed: () {
                      ref.read(goalListProvider.notifier).edit(goal.id, textController.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      style: TextStyle(color: Colors.black),
                      '保存する',
                    ),
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