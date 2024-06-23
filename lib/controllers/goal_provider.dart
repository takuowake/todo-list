import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal_model.dart';

final goalListProvider = StateNotifierProvider<GoalListController, List<Goal>>((ref) {
  return GoalListController(ref);
});

final pastGoalsProvider = StateNotifierProvider<PastGoalsController, List<Goal>>((ref) {
  return PastGoalsController();
});

class GoalListController extends StateNotifier<List<Goal>> {
  final StateNotifierProviderRef<GoalListController, List<Goal>> ref;
  Map<String, Timer> _timers = {};

  GoalListController(this.ref) : super([]) {
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
          goal.copyWith(
            isCompleted: !goal.isCompleted,
            completionDate: !goal.isCompleted ? DateTime.now() : null,
          )
        else
          goal,
    ];
    _saveGoals();
    final toggledGoal = state.firstWhere((goal) => goal.id == id);
    if (toggledGoal.isCompleted) {
      _scheduleDeletion(toggledGoal);
    }
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
    _scheduleDeletion(editedGoal);
  }

  void _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = prefs.getStringList('goals') ?? [];
    state = goalList.map((goal) => Goal.fromJson(jsonDecode(goal))).toList();
    _sortGoals();
    for (var goal in state) {
      final duration = goal.isCompleted
          ? 24 - DateTime.now().difference(goal.completionDate!).inHours
          : 24 - DateTime.now().difference(goal.updatedTime).inHours;
      if (duration > 0) {
        _scheduleDeletion(goal);
      } else {
        remove(goal.id);
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
    _timers[goal.id]?.cancel();
    final duration = goal.isCompleted
        ? Duration(hours: 24 - DateTime.now().difference(goal.completionDate!).inHours)
        : Duration(hours: 24 - DateTime.now().difference(goal.updatedTime).inHours);
    var timer = Timer(duration, () {
      remove(goal.id);
      if (goal.isCompleted) {
        ref.read(pastGoalsProvider.notifier).add(goal);
      }
    });
    _timers[goal.id] = timer;
  }
}

class PastGoalsController extends StateNotifier<List<Goal>> {
  PastGoalsController() : super([]);

  void add(Goal goal) {
    state = [...state, goal];
    _savePastGoals();
  }

  void remove(String id) {
    state = state.where((goal) => goal.id != id).toList();
    _savePastGoals();
  }

  void _loadPastGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = prefs.getStringList('past_goals') ?? [];
    state = goalList.map((goal) => Goal.fromJson(jsonDecode(goal))).toList();
  }

  void _savePastGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = state.map((goal) => jsonEncode(goal.toJson())).toList();
    await prefs.setStringList('past_goals', goalList);
  }
}