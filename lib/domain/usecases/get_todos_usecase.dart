import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUsecase {
  GetTodosUsecase(this.repository);

  final TodoRepository repository;

  Future<List<TodoEntity>> call({required bool isConnected}) {
    return repository.getTodos(isConnected: isConnected);
  }
}
