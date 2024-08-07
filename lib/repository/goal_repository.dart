// goal_repository.dart
// このファイルは、目標データの取得・保存ロジックを提供します。

import 'package:goal_list/models/goal.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalRepository {
  final SupabaseClient _client;
  final Logger _logger = Logger();

  GoalRepository(this._client);

  // Supabaseから目標リストを取得するメソッド
  Future<List<Goal>> fetchGoals(String user_id) async {
    try {
      final data = await _client.from('goals').select().eq('user_id', user_id) as List<dynamic>;
      return data.map((goal) => Goal.fromJson(goal)).toList();
    } catch (e) {
      _logger.e('fetchGoals is error: $e');
      return [];
    }
  }

  // Supabaseに新しい目標を追加するメソッド
  Future<void> addGoal(Goal goal) async {
    try {
      await _client.from('goals').insert(goal.toJson());
    } catch (e) {
      _logger.e('addGoal is error: $e');
    }
  }

  // Supabase上の目標データを更新するメソッド
  Future<void> updateGoal(Goal goal) async {
    try {
      await _client.from('goals').update(goal.toJson()).eq('id', goal.id);
    } catch (e) {
      _logger.e('updateGoal is error: $e');
    }
  }

  // Supabase上の目標データを削除するメソッド
  Future<void> deleteGoal(String id) async {
    try {
      await _client.from('goals').delete().eq('id', id);
    } catch (e) {
      _logger.e('deleteGoal is error: $e');
    }
  }
}