import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../controllers/todo_provider.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy/MM/dd').format(now);

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
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final todo = todoList[index];
              final isEditable = DateTime.now().difference(todo.createdTime).inHours < 24;
              return ListTile(
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
                          _promptEditTodo(context, ref, index, todo.title);
                        },
                      ),
                    IconButton(
                      icon: Icon(todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
                      onPressed: () {
                        ref.read(todoListProvider.notifier).toggleComplete(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(todoListProvider.notifier).remove(index);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  ref.read(todoListProvider.notifier).toggleComplete(index);
                },
              );
            },
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
                ref.read(todoListProvider.notifier).add(textController.text);
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

  void _promptEditTodo(BuildContext context, WidgetRef ref, int index, String currentTitle) {
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
                ref.read(todoListProvider.notifier).edit(index, textController.text);
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