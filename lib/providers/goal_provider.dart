// goal_provider.dart
// このファイルは、目標データの状態管理を提供します。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/models/goal.dart';
import 'package:goal_list/repository/goal_repository.dart';
import 'package:goal_list/services/goal_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalListNotifier extends StateNotifier<List<Goal>> {
  final GoalService _service;

  GoalListNotifier(this._service) : super([]);

  Future<void> loadGoals() async {
    final goals = await _service.getGoals();
    state = goals;
  }

  void add(Goal goal) async {
    await _service.addGoal(goal);
    state = [...state, goal];
  }

  void edit(String id, String title) async {
    final index = state.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final updatedGoal = state[index].copyWith(title: title, updatedTime: DateTime.now());
    await _service.updateGoal(updatedGoal);
    state = [...state]..[index] = updatedGoal;
  }

  void remove(String id) async {
    await _service.deleteGoal(id);
    state = state.where((goal) => goal.id != id).toList();
  }

  void toggleComplete(String id) async {
    final index = state.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final updatedGoal = state[index].copyWith(
      isCompleted: !state[index].isCompleted,
      updatedTime: DateTime.now(),
      completionDate: state[index].isCompleted ? null : DateTime.now(),
    );
    await _service.updateGoal(updatedGoal);
    state = [...state]..[index] = updatedGoal;
  }
}

final goalListProvider = StateNotifierProvider<GoalListNotifier, List<Goal>>((ref) {
  final service = ref.read(goalServiceProvider);
  return GoalListNotifier(service);
});

final goalServiceProvider = Provider<GoalService>((ref) {
  final repository = ref.read(goalRepositoryProvider);
  return GoalService(repository);
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final client = SupabaseClient('supabaseUrl', 'supabaseKey');
  return GoalRepository(client);
});