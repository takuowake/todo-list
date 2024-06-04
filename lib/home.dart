import 'package:flutter/material.dart';
import 'package:todo_list/views/settings_screen.dart';
import 'package:todo_list/views/todo_list_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[
        SettingsScreen(),
        TodoListScreen(),
      ],
    );
  }
}