import 'package:flutter/material.dart';

import '../../core/theme/design_system.dart';
import '../../domain/entities/todo_entity.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({super.key, required this.todo});

  final TodoEntity todo;

  @override
  Widget build(BuildContext context) {
    final statusColor = todo.completed ? AppColors.success : AppColors.warning;
    final statusText = todo.completed ? 'Concluída' : 'Pendente';

    return Card(
      color: AppColors.cardBackground,
      child: ListTile(
        leading: Icon(
          todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: statusColor,
        ),
        title: Text(todo.title),
        subtitle: Text(
          statusText,
          style: TextStyle(color: statusColor),
        ),
      ),
    );
  }
}
