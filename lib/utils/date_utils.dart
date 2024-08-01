// date_utils.dart
// このファイルは、日付関連のユーティリティ関数を提供します。

import 'package:intl/intl.dart';

// 日付をフォーマットするユーティリティ関数
String formatDate(DateTime date) {
  return DateFormat('yyyy/MM/dd').format(date);
}

// 時間をフォーマットするユーティリティ関数
String formatTime(DateTime date) {
  return DateFormat('HH:mm').format(date);
}