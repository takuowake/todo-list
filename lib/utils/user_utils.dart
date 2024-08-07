// user_utils.dart
// このファイルは、ユーザーIDを生成・保存・取得するためのユーティリティ関数を提供します。

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserUtils {
  static const String user_idKey = 'user_id';

  // ユーザーIDを取得する関数
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString(user_idKey);

    if (user_id == null) {
      // ユーザーIDが存在しない場合、新しく生成して保存
      user_id = Uuid().v4();
      await prefs.setString(user_idKey, user_id);
    }

    return user_id;
  }
}