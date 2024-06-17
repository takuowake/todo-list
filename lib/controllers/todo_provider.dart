import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

final goalListProvider = StateNotifierProvider<TodoListController, List<Todo>>((ref) {
  return TodoListController();
});

class TodoListController extends StateNotifier<List<Todo>> {
  Map<String, Timer> _timers = {};

  TodoListController() : super([]) {
    _loadTodos();
  }

  void add(Todo todo) {
    state = [...state, todo];
    _saveTodos();
    _scheduleDeletion(todo);
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _saveTodos();
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
    _saveTodos();
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
    _saveTodos();

    final editedTodo = newList.firstWhere((todo) => todo.id == id);
    _scheduleDeletion(editedTodo); // 編集時にタイマーをリセット
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = prefs.getStringList('todos') ?? [];
    state = goalList.map((todo) => Todo.fromJson(jsonDecode(todo))).toList();
    _sortTodos();
    for (var todo in state) {
      if (DateTime.now().difference(todo.updatedTime).inHours < 24) {
        _scheduleDeletion(todo);
      } else {
        remove(todo.id); // 24時間を超えていたら直接削除
      }
    }
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final goalList = state.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', goalList);
  }

  void _sortTodos() {
    state = [
      ...state.where((todo) => !todo.isCompleted && DateTime.now().difference(todo.createdTime).inHours < 24),
      ...state.where((todo) => !todo.isCompleted && DateTime.now().difference(todo.createdTime).inHours >= 24),
      ...state.where((todo) => todo.isCompleted),
    ];
  }

  void _scheduleDeletion(Todo todo) {
    _timers[todo.id]?.cancel(); // 既存のタイマーをキャンセル
    var timer = Timer(Duration(hours: 24 - DateTime.now().difference(todo.updatedTime).inHours), () => remove(todo.id));
    _timers[todo.id] = timer;
  }
}