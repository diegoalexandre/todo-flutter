import '../../core/errors/app_exceptions.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/todo_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/remote/todo_remote_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({
    required this.authRemoteDataSource,
    required this.todoRemoteDataSource,
    required this.todoLocalDataSource,
  });

  final AuthRemoteDataSource authRemoteDataSource;
  final TodoRemoteDataSource todoRemoteDataSource;
  final TodoLocalDataSource todoLocalDataSource;

  @override
  Future<List<TodoEntity>> getTodos({required bool isConnected}) async {
    return _loadTodos(isConnected: isConnected);
  }

  @override
  Future<List<TodoEntity>> syncTodos({required bool isConnected}) async {
    return _loadTodos(isConnected: isConnected);
  }

  Future<List<TodoEntity>> _loadTodos({required bool isConnected}) async {
    try {
      if (isConnected) {
        try {
          final token = await authRemoteDataSource.authenticate(
            login: ApiConstants.loginValue,
            password: ApiConstants.passwordValue,
          );
          final remoteTodos = await todoRemoteDataSource.getTodos(token);
          await todoLocalDataSource.cacheTodos(remoteTodos);
          return remoteTodos;
        } catch (_) {
          // Se houver falha no remoto, tenta cache offline antes de propagar erro.
          final cached = await todoLocalDataSource.getCachedTodos();
          if (cached.isNotEmpty) return cached;
          rethrow;
        }
      }
      return await todoLocalDataSource.getCachedTodos();
    } catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  String _extractMessage(Object error) {
    if (error is AppException) return error.message;
    return error.toString();
  }
}
