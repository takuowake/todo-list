// user_utils.dart
// このファイルは、ユーザーIDを生成・保存・取得するためのユーティリティ関数を提供します。

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserUtils {
  static const String userIdKey = 'userId';

  // ユーザーIDを取得する関数
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(userIdKey);

    if (userId == null) {
      // ユーザーIDが存在しない場合、新しく生成して保存
      userId = Uuid().v4();
      await prefs.setString(userIdKey, userId);
    }

    return userId;
  }
}