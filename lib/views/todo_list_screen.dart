import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo_model.dart';
import '../controllers/todo_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/todo_provider.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  bool showCompletedTasks = false;

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoListProvider);
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd').format(now);

    final incompleteTodos = todoList.where((todo) => !todo.isCompleted).toList();
    final completedTodos = todoList.where((todo) => todo.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(formattedDate),
      ),
      body: Stack(
        children: [
          // 背景画像
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // 透明な背景を持つListView
          ListView.builder(
            itemCount: incompleteTodos.length,
            itemBuilder: (context, index) {
              final todo = incompleteTodos[index];
              final isEditable = DateTime.now().difference(todo.createdTime).inHours < 24;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isEditable)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _promptEditTodo(context, ref, todo.id, todo.title);
                          },
                        ),
                      IconButton(
                        icon: Icon(todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
                        onPressed: () {
                          ref.read(todoListProvider.notifier).toggleComplete(todo.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref.read(todoListProvider.notifier).remove(todo.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    ref.read(todoListProvider.notifier).toggleComplete(todo.id);
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    showCompletedTasks = !showCompletedTasks;
                  });
                },
                icon: Icon(showCompletedTasks ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                label: Text(showCompletedTasks ? '完了済みのタスクを隠す' : '🔻完了済みのタスクを見る'),
              ),
            ),
          ),
          if (showCompletedTasks)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: completedTodos.length,
                  itemBuilder: (context, index) {
                    final todo = completedTodos[index];
                    return ListTile(
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              ref.read(todoListProvider.notifier).remove(todo.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _promptAddTodo(context, ref);
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _promptAddTodo(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ToDoを追加する'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'ToDo'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                final newTodo = Todo(
                  id: UniqueKey().toString(),
                  title: textController.text,
                  createdTime: DateTime.now(),
                );
                ref.read(todoListProvider.notifier).add(newTodo);
                textController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('保存する'),
            ),
          ],
        );
      },
    );
  }

  void _promptEditTodo(BuildContext context, WidgetRef ref, String id, String currentTitle) {
    final textController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ToDoを編集する'),
          content: TextField(
            controller: textController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                ref.read(todoListProvider.notifier).edit(id, textController.text);
                Navigator.of(context).pop();
              },
              child: const Text('保存する'),
            ),
          ],
        );
      },
    );
  }
}