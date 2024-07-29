// settings_screen.dart
// このファイルは、設定画面のUIを構築し、各設定項目への遷移を管理します。

import 'package:flutter/material.dart';
import 'package:goal_list/views/contact_us_screen.dart';
import 'package:goal_list/views/past_goals_screen.dart';
import 'package:goal_list/views/privacy_policy_screen.dart';
import 'package:goal_list/views/terms_of_service_screen.dart';
import 'package:goal_list/views/widgets/custom_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBackPressed;

  SettingsScreen({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: onBackPressed,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 100.0, left: 10, right: 10), // 全体の余白を追加
          children: [
            buildCustomListTile(
              context: context,
              title: '過去の目標一覧',
              destination: PastGoalsScreen(),
            ),
            buildCustomListTile(
              context: context,
              title: '利用規約',
              destination: TermsOfServiceScreen(),
            ),
            buildCustomListTile(
              context: context,
              title: 'プライバシーポリシー',
              destination: PrivacyPolicyScreen(),
            ),
            buildCustomListTile(
              context: context,
              title: 'お問い合わせ',
              destination: ContactUsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}