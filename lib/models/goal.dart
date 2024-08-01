// goal.dart
// このファイルは、目標データモデルを定義します。

class Goal {
  final String id;
  final String userId; // ユーザーIDフィールドを追加
  final String title;
  final DateTime createdTime;
  final DateTime updatedTime;
  final bool isCompleted;
  final DateTime? completionDate;

  Goal({
    required this.id,
    required this.userId, // ユーザーIDを追加
    required this.title,
    required this.createdTime,
    required this.updatedTime,
    this.isCompleted = false,
    this.completionDate,
  });

  Goal copyWith({String? userId, String? title, DateTime? updatedTime, bool? isCompleted, DateTime? completionDate}) {
    return Goal(
      id: id,
      userId: userId ?? this.userId, // ユーザーIDをコピー
      title: title ?? this.title,
      createdTime: createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      isCompleted: isCompleted ?? this.isCompleted,
      completionDate: completionDate ?? this.completionDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId, // ユーザーIDをJSONに変換
      'title': title,
      'createdTime': createdTime.toIso8601String(),
      'updatedTime': updatedTime.toIso8601String(),
      'isCompleted': isCompleted,
      'completionDate': completionDate?.toIso8601String(),
    };
  }

  static Goal fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      userId: json['userId'], // JSONからユーザーIDを取得
      title: json['title'],
      createdTime: DateTime.parse(json['createdTime']),
      updatedTime: DateTime.parse(json['updatedTime']),
      isCompleted: json['isCompleted'],
      completionDate: json['completionDate'] != null ? DateTime.parse(json['completionDate']) : null,
    );
  }
}