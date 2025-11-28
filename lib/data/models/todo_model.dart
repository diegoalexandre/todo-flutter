import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  const TodoModel({
    required super.id,
    required super.title,
    required super.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString() ?? '',
      completed: json['completed'] == true || json['completed'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'completed': completed,
      };

  static List<TodoModel> fromList(List<dynamic> data) {
    return data
        .map((item) => TodoModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
