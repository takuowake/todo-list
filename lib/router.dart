import 'package:go_router/go_router.dart';
import 'package:todo_list/views/settings_screen.dart';
import 'package:todo_list/views/todo_list_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => TodoListScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => SettingsScreen(),
    ),
  ],
);