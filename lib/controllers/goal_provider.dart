import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal_model.dart';

final goalListProvider = StateNotifierProvider<GoalListController, List<Goal>>((ref) {
  return GoalListController();
});

class GoalListController extends StateNotifier<List<Goal>> {
  Map<String, Timer> _timers = {};

  GoalListController() : super([]) {
    _loadGoals();
  }

  void add(Goal goal) {
    state = [...state, goal];
    _saveGoals();
    _scheduleDeletion(goal);
  }

  void remove(String id) {
    state = state.where((goal) => goal.id != id).toList();
    _saveGoals();
    _timers[id]?.cancel();
    _timers.remove(id);
  }

  void toggleComplete(String id) {
    state = [
      for (final goal in state)
        if (goal.id == id)
          goal.copyWith(isCompleted: !goal.isCompleted)
        else
          goal,
    ];
    _saveGoals();
  }

  void edit(String id, String newTitle) {
    final newList = [
      for (final goal in state)
        if (goal.id == id)
          goal.copyWith(title: newTitle, updatedTime: DateTime.now())
        else
          goal,
    ];
    state = newList;
    _saveGoals();

    final editedGoal = newList.firstWhere((goal) => goal.id == id);
    _scheduleDeletion(editedGoal); // 編集時にタイマーをリセット
  }

  void _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = prefs.getStringList('goals') ?? [];
    state = goalList.map((goal) => Goal.fromJson(jsonDecode(goal))).toList();
    _sortGoals();
    for (var goal in state) {
      if (DateTime.now().difference(goal.updatedTime).inHours < 24) {
        _scheduleDeletion(goal);
      } else {
        remove(goal.id); // 24時間を超えていたら直接削除
      }
    }
  }

  void _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = state.map((goal) => jsonEncode(goal.toJson())).toList();
    await prefs.setStringList('goals', goalList);
  }

  void _sortGoals() {
    state = [
      ...state.where((goal) => !goal.isCompleted && DateTime.now().difference(goal.createdTime).inHours < 24),
      ...state.where((goal) => !goal.isCompleted && DateTime.now().difference(goal.createdTime).inHours >= 24),
      ...state.where((goal) => goal.isCompleted),
    ];
  }

  void _scheduleDeletion(Goal goal) {
    _timers[goal.id]?.cancel(); // 既存のタイマーをキャンセル
    var timer = Timer(Duration(hours: 24 - DateTime.now().difference(goal.updatedTime).inHours), () => remove(goal.id));
    _timers[goal.id] = timer;
  }
}