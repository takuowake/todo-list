import 'dart:convert';

class Todo {
  final String title;
  final DateTime createdTime;
  final bool isCompleted;

  Todo({
    required this.title,
    required this.createdTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'createdTime': createdTime.toIso8601String(),
    'isComplete': isCompleted,
  };

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      createdTime: DateTime.parse(map['createdTime']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(jsonDecode(source));
}