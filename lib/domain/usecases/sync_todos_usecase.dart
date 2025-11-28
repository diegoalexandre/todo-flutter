import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class SyncTodosUsecase {
  SyncTodosUsecase(this.repository);

  final TodoRepository repository;

  Future<List<TodoEntity>> call({required bool isConnected}) {
    return repository.syncTodos(isConnected: isConnected);
  }
}
