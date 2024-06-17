import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

final goalListProvider = StateNotifierProvider<GoalListController, List<Goal>>((ref) {
  return GoalListController();
});

class GoalListController extends StateNotifier<List<Goal>> {
  Map<String, Timer> _timers = {};

  GoalListController() : super([]) {
    _loadGoals();
  }

  void add(Goal todo) {
    state = [...state, todo];
    _saveGoals();
    _scheduleDeletion(todo);
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _saveGoals();
    _timers[id]?.cancel();
    _timers.remove(id);
  }

  void toggleComplete(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
    _saveGoals();
  }

  void edit(String id, String newTitle) {
    final newList = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(title: newTitle, updatedTime: DateTime.now())
        else
          todo,
    ];
    state = newList;
    _saveGoals();

    final editedGoal = newList.firstWhere((todo) => todo.id == id);
    _scheduleDeletion(editedGoal); // 編集時にタイマーをリセット
  }

  void _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = prefs.getStringList('todos') ?? [];
    state = goalList.map((todo) => Goal.fromJson(jsonDecode(todo))).toList();
    _sortGoals();
    for (var todo in state) {
      if (DateTime.now().difference(todo.updatedTime).inHours < 24) {
        _scheduleDeletion(todo);
      } else {
        remove(todo.id); // 24時間を超えていたら直接削除
      }
    }
  }

  void _saveGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = state.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', goalList);
  }

  void _sortGoals() {
    state = [
      ...state.where((todo) => !todo.isCompleted && DateTime.now().difference(todo.createdTime).inHours < 24),
      ...state.where((todo) => !todo.isCompleted && DateTime.now().difference(todo.createdTime).inHours >= 24),
      ...state.where((todo) => todo.isCompleted),
    ];
  }

  void _scheduleDeletion(Goal todo) {
    _timers[todo.id]?.cancel(); // 既存のタイマーをキャンセル
    var timer = Timer(Duration(hours: 24 - DateTime.now().difference(todo.updatedTime).inHours), () => remove(todo.id));
    _timers[todo.id] = timer;
  }
}