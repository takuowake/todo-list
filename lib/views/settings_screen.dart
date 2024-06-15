import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/views/privacy_policy_screen.dart';
import 'package:todo_list/views/terms_of_service_screen.dart';

class SettingsScreen extends ConsumerWidget {
  final VoidCallback onBackPressed;

  SettingsScreen({required this.onBackPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              onBackPressed();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), // 背景画像のパス
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
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
              title: Text('チュートリアル'),
              onTap: () {
                // チュートリアル画面に遷移するロジックを追加
              },
            ),
            ListTile(
              title: Text('お問い合わせ'),
              onTap: () {
                // お問い合わせ画面に遷移するロジックを追加
              },
            ),
          ],
        ),
      ),
    );
  }
}