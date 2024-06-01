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

  void add(String title) {
    final newTodo = Todo(
      title: title,
      createdTime: DateTime.now(),
    );
    state = [...state, newTodo];
    _saveTodos();
  }

  void remove(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
    _saveTodos();
  }

  void toggleComplete(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Todo(
            title: state[i].title,
            createdTime: state[i].createdTime,
            isCompleted: !state[i].isCompleted,
          )
        else
          state[i],
    ];
    _saveTodos();
  }

  void edit(int index, String newTitle) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Todo(
            title: newTitle,
            createdTime: state[i].createdTime,
            isCompleted: state[i].isCompleted,
          )
        else
          state[i],
    ];
    _saveTodos();
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = prefs.getStringList('todos') ?? [];
    state = todoList.map((todo) => Todo.fromJson(todo)).toList();
    _sortTodos();
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = state.map((todo) => todo.toJson()).toList();
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