import 'dart:convert';

class Goal {
  final String id;
  final String title;
  final DateTime createdTime;
  final DateTime updatedTime;
  final bool isCompleted;

  Goal({
    required this.id,
    required this.title,
    required this.createdTime,
    required this.updatedTime,
    this.isCompleted = false,
  });

  Goal copyWith({String? title, DateTime? updatedTime, bool? isCompleted}) {
    return Goal(
      id: id,
      title: title ?? this.title,
      createdTime: createdTime,
      updatedTime: updatedTime ?? this.updatedTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdTime': createdTime.toIso8601String(),
      'updatedTime': updatedTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  static Goal fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      createdTime: DateTime.parse(json['createdTime']),
      updatedTime: DateTime.parse(json['updatedTime']),
      isCompleted: json['isCompleted'],
    );
  }
}