import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos({required bool isConnected});
  Future<List<TodoEntity>> syncTodos({required bool isConnected});
}
