// goal_list_screen.dart
// このファイルは、目標一覧画面のUIを構築し、ユーザーが目標を追加、編集、完了済み目標の表示を行うためのロジックを提供します。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/providers/goal_provider.dart';
import 'package:goal_list/views/add_goal_screen.dart';
import 'package:goal_list/views/completed_goals_bottom_sheet.dart';
import 'package:goal_list/views/goal_tile.dart';

class GoalListScreen extends ConsumerWidget {
  final VoidCallback onSettingsPressed;

  GoalListScreen({required this.onSettingsPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalList = ref.watch(goalListProvider).where((goal) => !goal.is_completed).toList(); // 未完了の目標のみ表示

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          style: Theme.of(context).textTheme.headlineSmall,
          '目標一覧',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onSettingsPressed,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGoalScreen()),
              );
            },
            tooltip: 'Add Task',
          ),
        ],
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
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: goalList.length,
                    itemBuilder: (context, index) {
                      final goal = goalList[index];
                      return GoalListTile(goal: goal);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => CompletedGoalsBottomSheet(),
                      );
                    },
                    child: Text(
                      style: TextStyle(color: Colors.black),
                      '24時間以内の完了済み目標を見る',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}