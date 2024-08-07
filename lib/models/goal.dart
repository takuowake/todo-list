// goal.dart
// このファイルは、目標データモデルを定義します。

class Goal {
  final String id;
  final String userId; // ユーザーIDフィールドを追加
  final String title;
  final DateTime created_time;
  final DateTime updated_time;
  final bool is_completed;
  final DateTime? completionDate;

  Goal({
    required this.id,
    required this.userId, // ユーザーIDを追加
    required this.title,
    required this.created_time,
    required this.updated_time,
    this.is_completed = false,
    this.completionDate,
  });

  Goal copyWith({String? userId, String? title, DateTime? updated_time, bool? is_completed, DateTime? completionDate}) {
    return Goal(
      id: id,
      userId: userId ?? this.userId, // ユーザーIDをコピー
      title: title ?? this.title,
      created_time: created_time,
      updated_time: updated_time ?? this.updated_time,
      is_completed: is_completed ?? this.is_completed,
      completionDate: completionDate ?? this.completionDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId, // ユーザーIDをJSONに変換
      'title': title,
      'created_time': created_time.toIso8601String(),
      'updated_time': updated_time.toIso8601String(),
      'is_completed': is_completed,
      'completionDate': completionDate?.toIso8601String(),
    };
  }

  static Goal fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['userId'], // JSONからユーザーIDを取得
      title: json['title'],
      created_time: DateTime.parse(json['created_time']),
      updated_time: DateTime.parse(json['updated_time']),
      is_completed: json['is_completed'],
      completionDate: json['completionDate'] != null ? DateTime.parse(json['completionDate']) : null,
    );
  }
}