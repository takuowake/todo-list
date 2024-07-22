// settings_screen.dart
// このファイルは、設定画面のUIを構築し、各設定項目への遷移を管理します。

import 'package:flutter/material.dart';
import 'package:goal_list/views/contact_us_screen.dart';
import 'package:goal_list/views/past_goals_screen.dart';
import 'package:goal_list/views/privacy_policy_screen.dart';
import 'package:goal_list/views/terms_of_service_screen.dart';

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
          children: [
            ListTile(
              title: Text('過去の目標一覧'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PastGoalsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('利用規約'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsOfServiceScreen()),
                );
              },
            ),
            ListTile(
              title: Text('プライバシーポリシー'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
            ListTile(
              title: Text('お問い合わせ'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}