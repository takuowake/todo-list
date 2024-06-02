import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo_model.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              _promptAddTodo(context, ref);
            },
            tooltip: 'Add Task',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (showCompletedTasks) {
            setState(() {
              showCompletedTasks = false;
            });
          }
        },
        child: Stack(
          children: [
            // 背景画像
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            // 透明な背景を持つListView
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: ListView.builder(
                itemCount: incompleteTodos.length,
                itemBuilder: (context, index) {
                  final todo = incompleteTodos[index];
                  final isEditable = DateTime.now().difference(todo.createdTime).inHours < 24;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
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
                              _showDeleteDialog(context, ref, todo.id);
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
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(16.0), // 余白を追加してボタンを中心に配置
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        showCompletedTasks = !showCompletedTasks;
                      });
                    },
                    icon: Icon(
                      showCompletedTasks ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: showCompletedTasks ? Colors.lightBlueAccent : Colors.black,
                    ),
                    label: Text(
                      showCompletedTasks ? '完了済みのタスクを隠す' : '完了済みのタスクを見る',
                      style: TextStyle(
                        color: showCompletedTasks ? Colors.lightBlueAccent : Colors.black,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // パディングを調整
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // ボタンを丸みを帯びた形に
                      ),
                      side: const BorderSide(color: Colors.white), // ボタンの外枠を設定
                    ),
                  ),
                ),
              ),
            ),
            if (showCompletedTasks)
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCompletedTasks = false;
                  });
                },
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/app_icon.png', // 背景画像のパスを指定
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8), // 背景の白い色も透けるようにする
                                borderRadius: BorderRadius.circular(20), // ボーダーの丸みを増やす
                              ),
                              padding: const EdgeInsets.all(8.0), // パディングを追加
                              child: ListView.builder(
                                itemCount: completedTodos.length,
                                itemBuilder: (context, index) {
                                  final todo = completedTodos[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5), // アイテム間にスペースを追加
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        todo.title,
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.reply),
                                            onPressed: () {
                                              _showRestoreDialog(context, ref, todo.id);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              _showDeleteDialog(context, ref, todo.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _promptAddTodo(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ToDoを追加'),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'ToDo'),
            maxLines: null,
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
          title: const Text('ToDoを編集'),
          content: TextField(
            controller: textController,
            autofocus: true,
            maxLines: null,
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String todoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ToDoを削除'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(todoListProvider.notifier).remove(todoId);
                Navigator.of(context).pop();
              },
              child: const Text('削除する'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref, String todoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('このToDoを戻しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(todoListProvider.notifier).toggleComplete(todoId);
                Navigator.of(context).pop();
              },
              child: const Text('はい'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }
}