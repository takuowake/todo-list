import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:goal_list/models/goal_model.dart';
import '../controllers/goal_provider.dart';

class GoalListScreen extends ConsumerStatefulWidget {
  final VoidCallback onSettingsPressed;

  GoalListScreen({required this.onSettingsPressed});

  @override
  _GoalListScreenState createState() => _GoalListScreenState();
}

class _GoalListScreenState extends ConsumerState<GoalListScreen> {
  bool showCompletedTasks = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final goalList = ref.watch(goalListProvider);
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd').format(now);

    final incompleteGoals = goalList.where((goal) => !goal.isCompleted).toList();
    final completedGoals = goalList.where((goal) => goal.isCompleted).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(child: Text(formattedDate)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: widget.onSettingsPressed,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              _promptAddGoal(context, ref);
            },
            tooltip: 'Add Task',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (showCompletedTasks) {
            setState(() {
              showCompletedTasks = false;
            });
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListView.builder(
                        key: ValueKey(showCompletedTasks), // Add this line
                        itemCount: incompleteGoals.length,
                        itemBuilder: (context, index) {
                          final goal = incompleteGoals[index];
                          final isEditable = DateTime.now().difference(goal.updatedTime).inHours < 24;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              key: ValueKey(goal.id), // Add this line
                              title: Text(
                                goal.title,
                                style: TextStyle(
                                  decoration: goal.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Text('残り: ${_formatRemainingTime(goal.updatedTime)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isEditable)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _promptEditGoal(context, ref, goal.id, goal.title);
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(goal.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
                                    onPressed: () {
                                      ref.read(goalListProvider.notifier).toggleComplete(goal.id);
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
                                ref.read(goalListProvider.notifier).toggleComplete(goal.id);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        showCompletedTasks = !showCompletedTasks;
                      });
                    },
                    icon: Icon(
                      showCompletedTasks ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: showCompletedTasks ? Colors.lightBlueAccent : Colors.black,
                    ),
                    label: Text(
                      showCompletedTasks ? '目標を隠す' : '24時間以内に設定した完了済みの目標を見る',
                      style: TextStyle(
                        color: showCompletedTasks ? Colors.lightBlueAccent : Colors.black,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            if (showCompletedTasks)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCompletedTasks = false;
                  });
                },
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: MediaQuery.of(context).size.height * 0.4, // 高さを変更
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/completed_goal_background.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // 背景の白い色も透けるようにする
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                itemCount: completedGoals.length,
                                itemBuilder: (context, index) {
                                  final goal = completedGoals[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5), // アイテム間にスペースを追加
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      key: ValueKey(goal.id), // Add this line
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
                                              _showDeleteDialog(context, ref, goal.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _promptAddGoal(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('目標を追加'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(labelText: '目標'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                final newGoal = Goal(
                  id: UniqueKey().toString(),
                  title: textController.text,
                  createdTime: DateTime.now(),
                  updatedTime: DateTime.now(),
                );
                ref.read(goalListProvider.notifier).add(newGoal);
                textController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('保存する'),
            ),
          ],
        );
      },
    );
  }

  void _promptEditGoal(BuildContext context, WidgetRef ref, String id, String currentTitle) {
    final textController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('目標を編集'),
          content: TextField(
            controller: textController,
            autofocus: true,
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                ref.read(goalListProvider.notifier).edit(id, textController.text);
                Navigator.of(context).pop();
              },
              child: const Text('保存する'),
            ),
          ],
        );
      },
    );
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
                ref.read(goalListProvider.notifier).remove(goalId);
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

  void _showRestoreDialog(BuildContext context, WidgetRef ref, String goalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('この目標を戻しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(goalListProvider.notifier).toggleComplete(goalId);
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