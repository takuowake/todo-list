import 'package:flutter/material.dart';
import 'package:todo_list/views/settings_screen.dart';
import 'package:todo_list/views/todo_list_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  void _goToSettings() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToTodoList() {
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: [
        SettingsScreen(onBackPressed: _goToTodoList),
        TodoListScreen(onSettingsPressed: _goToSettings),
      ],
    );
  }
}