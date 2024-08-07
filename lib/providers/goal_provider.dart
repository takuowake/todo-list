// goal_provider.dart
// このファイルは、目標データの状態管理を提供します。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/models/goal.dart';
import 'package:goal_list/repository/goal_repository.dart';
import 'package:goal_list/services/goal_service.dart';
import 'package:goal_list/utils/user_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalListNotifier extends StateNotifier<List<Goal>> {
  final GoalService _service;

  GoalListNotifier(this._service) : super([]) {
    _loadGoals();
  }

  // ユーザーIDを使用して目標リストをロードするメソッド
  Future<void> _loadGoals() async {
    final user_id = await UserUtils.getUserId();
    final goals = await _service.getGoals(user_id);
    state = _filterExpiredGoals(goals);
  }

  // 目標のリストから期限切れのものをフィルタリングするメソッド
  List<Goal> _filterExpiredGoals(List<Goal> goals) {
    final now = DateTime.now();
    return goals.where((goal) => goal.updated_time.add(Duration(hours: 24)).isAfter(now)).toList();
  }

  // 過去の目標（期限切れの目標）を取得するメソッド
  List<Goal> filterPastGoals() {
    final now = DateTime.now();
    return state.where((goal) => goal.updated_time.add(Duration(hours: 24)).isBefore(now)).toList();
  }

  // 新しい目標を追加するメソッド
  void add(Goal goal) async {
    await _service.addGoal(goal);
    state = _filterExpiredGoals([...state, goal]);
  }

  // 目標を編集するメソッド
  void edit(String id, String title) async {
    final index = state.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final updatedGoal = state[index].copyWith(title: title, updated_time: DateTime.now());
    await _service.updateGoal(updatedGoal);
    state = _filterExpiredGoals([...state]..[index] = updatedGoal);
  }

  // 目標を削除するメソッド
  void remove(String id) async {
    await _service.deleteGoal(id);
    state = state.where((goal) => goal.id != id).toList();
  }

  // 目標の完了状態を切り替えるメソッド
  void toggleComplete(String id) async {
    final index = state.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final updatedGoal = state[index].copyWith(
      is_completed: !state[index].is_completed,
      updated_time: DateTime.now(),
      completionDate: state[index].is_completed ? null : DateTime.now(),
    );
    await _service.updateGoal(updatedGoal);
    state = _filterExpiredGoals([...state]..[index] = updatedGoal);
  }
}

// 目標リストのプロバイダー
final goalListProvider = StateNotifierProvider<GoalListNotifier, List<Goal>>((ref) {
  final service = ref.read(goalServiceProvider);
  return GoalListNotifier(service);
});

// 目標サービスのプロバイダー
final goalServiceProvider = Provider<GoalService>((ref) {
  final repository = ref.read(goalRepositoryProvider);
  return GoalService(repository);
});

// 目標リポジトリのプロバイダー
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final client = Supabase.instance.client;
  return GoalRepository(client);
});

// 期限切れの目標を取得するプロバイダー
final expiredGoalsProvider = Provider<List<Goal>>((ref) {
  final allGoals = ref.watch(goalListProvider);
  final now = DateTime.now();
  return allGoals.where((goal) => goal.updated_time.add(Duration(hours: 24)).isBefore(now)).toList();
});

// TextEditingControllerの状態を管理するProvider
final textFieldProvider = StateProvider<String>((ref) => '');