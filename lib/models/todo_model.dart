import 'dart:convert';

class Todo {
  final String id;
  final String title;
  final DateTime createdTime;
  final DateTime updatedTime;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.createdTime,
    required this.updatedTime,
    this.isCompleted = false,
  });

  Todo copyWith({String? title, DateTime? updatedTime, bool? isCompleted}) {
    return Todo(
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

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      createdTime: DateTime.parse(json['createdTime']),
      updatedTime: DateTime.parse(json['updatedTime']),
      isCompleted: json['isCompleted'],
    );
  }
}