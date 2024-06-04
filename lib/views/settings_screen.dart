import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_list/views/todo_list_screen.dart';

class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'), // 背景画像のパス
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: Text('Settings'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TodoListScreen()),
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('利用規約'),
                        onTap: () {
                          // 利用規約画面に遷移するロジックを追加
                        },
                      ),
                      ListTile(
                        title: Text('プライバシーポリシー'),
                        onTap: () {
                          // プライバシーポリシー画面に遷移するロジックを追加
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}