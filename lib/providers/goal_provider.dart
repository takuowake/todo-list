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
  List<Goal> _allGoals = []; // 全ての目標を保持するリストを初期化

  GoalListNotifier(this._service) : super([]) {
    loadGoals();
  }

  // ユーザーIDを使用して目標リストをロードするメソッド
  Future<void> loadGoals() async {
    final userId = await UserUtils.getUserId();
    final goals = await _service.getGoals(userId);
    _allGoals = goals;
    state = _filterActiveGoals(goals);
  }

  // 目標のリストから期限切れのものをフィルタリングするメソッド
  List<Goal> _filterActiveGoals(List<Goal> goals) {
    final now = DateTime.now();
    return goals.where((goal) => goal.updatedTime.add(Duration(hours: 24)).isAfter(now)).toList();
  }

  // 過去の目標リストを取得するメソッド
  List<Goal> getPastGoals() {
    final now = DateTime.now();
    return _allGoals.where((goal) => goal.updatedTime.add(Duration(hours: 24)).isBefore(now)).toList();
  }

  // 新しい目標を追加するメソッド
  void add(Goal goal) async {
    await _service.addGoal(goal);
    _allGoals.add(goal);
    state = _filterActiveGoals(_allGoals);
  }

  // 目標を編集するメソッド
  void edit(String id, String title) async {
    final index = _allGoals.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final updatedGoal = _allGoals[index].copyWith(title: title, updatedTime: DateTime.now());
    await _service.updateGoal(updatedGoal);
    _allGoals[index] = updatedGoal;
    state = _filterActiveGoals(_allGoals);
  }

  // 目標を削除するメソッド
  void remove(String id) async {
    await _service.deleteGoal(id);
    _allGoals = _allGoals.where((goal) => goal.id != id).toList();
    state = _filterActiveGoals(_allGoals);
  }

  // 目標の完了状態を切り替えるメソッド
  void toggleComplete(String id) async {
    final index = _allGoals.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final updatedGoal = _allGoals[index].copyWith(
      isCompleted: !state[index].isCompleted,
      updatedTime: DateTime.now(),
      completionDate: state[index].isCompleted ? null : DateTime.now(),
    );
    await _service.updateGoal(updatedGoal);
    _allGoals[index] = updatedGoal;
    state = _filterActiveGoals(_allGoals);
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

// TextEditingControllerの状態を管理するProvider
final textFieldProvider = StateProvider<String>((ref) => '');