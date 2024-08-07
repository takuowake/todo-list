// goal_service.dart
// このファイルは、ビジネスロジックを実行します。

import 'package:goal_list/models/goal.dart';
import 'package:goal_list/repository/goal_repository.dart';

class GoalService {
  final GoalRepository _repository;

  GoalService(this._repository);

  Future<List<Goal>> getGoals(String user_id) async {
    return await _repository.fetchGoals(user_id);
  }

  Future<void> addGoal(Goal goal) async {
    await _repository.addGoal(goal);
  }

  Future<void> updateGoal(Goal goal) async {
    await _repository.updateGoal(goal);
  }

  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
  }
}