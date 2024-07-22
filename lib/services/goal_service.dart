// goal_service.dart
// このファイルは、ビジネスロジックを実行します。

import 'package:goal_list/models/goal.dart';
import 'package:goal_list/repository/goal_repository.dart';

class GoalService {
  final GoalRepository _repository;

  GoalService(this._repository);

  // 目標リストを取得するメソッド
  Future<List<Goal>> getGoals() async {
    return await _repository.fetchGoals();
  }

  // 新しい目標を追加するメソッド
  Future<void> addGoal(Goal goal) async {
    await _repository.addGoal(goal);
  }

  // 目標を更新するメソッド
  Future<void> updateGoal(Goal goal) async {
    await _repository.updateGoal(goal);
  }

  // 目標を削除するメソッド
  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
  }
}