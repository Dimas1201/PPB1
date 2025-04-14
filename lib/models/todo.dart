import 'package:hive/hive.dart';

part 'todo.g.dart'; // untuk generate adapter

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  bool isEditing;

  Todo({
    required this.title,
    this.isCompleted = false,
    this.isEditing = false,
  });

  // Setter dan getter untuk isEditing dan title
  setEditing(bool value) {
    isEditing = value;
  }

  setTitle(String value) {
    title = value;
  }

  // Toggle status completion
  toggleCompletion() {
    isCompleted = !isCompleted;
  }

  // Convert todo menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Membuat Todo dari JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }
}
