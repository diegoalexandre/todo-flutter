import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  const TodoEntity({
    required this.id,
    required this.title,
    required this.completed,
  });

  final int id;
  final String title;
  final bool completed;

  @override
  List<Object?> get props => [id, title, completed];
}
