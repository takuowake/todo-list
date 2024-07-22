// goal_service.dart
// このファイルは、ビジネスロジックを実行します。

import 'package:goal_list/models/goal.dart';
import 'package:goal_list/repository/goal_repository.dart';

class GoalService {
  final GoalRepository _repository;

  GoalService(this._repository);

  Future<List<Goal>> getGoals() async {
    return await _repository.fetchGoals();
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