import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

final todoListProvider = StateNotifierProvider<TodoListController, List<Todo>>((ref) {
  return TodoListController();
});

class TodoListController extends StateNotifier<List<Todo>> {
  TodoListController() : super([]) {
    _loadTodos();
  }

  void add(Todo todo) {
    state = [...state, todo];
    _saveTodos();
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _saveTodos();
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
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(title: newTitle)
        else
          todo,
    ];
    _saveTodos();
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = prefs.getStringList('todos') ?? [];
    state = todoList.map((todo) => Todo.fromJson(jsonDecode(todo))).toList();
    _sortTodos();
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = state.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', todoList);
  }

  void _sortTodos() {
    state = [
      ...state.where((todo) => !todo.isCompleted && DateTime.now().difference(todo.createdTime).inHours < 24),
      ...state.where((todo) => !todo.isCompleted && DateTime.now().difference(todo.createdTime).inHours >= 24),
      ...state.where((todo) => todo.isCompleted),
    ];
  }
}