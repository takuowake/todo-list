// date_utils.dart
// このファイルは、日付関連のユーティリティ関数を提供します。

import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('yyyy/MM/dd').format(date);
}

String formatTime(DateTime date) {
  return DateFormat('HH:mm').format(date);
}