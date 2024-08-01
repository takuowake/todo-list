// home.dart
// このファイルは、ホーム画面のUIを構築し、設定画面と目標一覧画面を切り替えるためのロジックを提供します。

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_list/views/goal_list_screen.dart';
import 'package:goal_list/views/settings_screen.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PageController _pageController = PageController(initialPage: 0);

    void _goToSettings() {
      _pageController.animateToPage(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    void _goToGoalList() {
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return PageView(
      controller: _pageController,
      children: [
        SettingsScreen(onBackPressed: _goToGoalList),
        GoalListScreen(onSettingsPressed: _goToSettings),
      ],
    );
  }
}