import 'dart:convert';

class Todo {
  final String id;
  final String title;
  final DateTime createdTime;
  final bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.createdTime,
    this.isCompleted = false,
  });

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      createdTime: createdTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdTime': createdTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      createdTime: DateTime.parse(json['createdTime']),
      isCompleted: json['isCompleted'],
    );
  }
}