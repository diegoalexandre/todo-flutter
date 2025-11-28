import 'package:hive/hive.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/utils/constants.dart';
import '../../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<List<TodoModel>> getCachedTodos();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  TodoLocalDataSourceImpl(this._box);

  final Box _box;

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    try {
      final serialized = todos.map((todo) => todo.toJson()).toList();
      await _box.put(CacheKeys.todosKey, serialized);
    } catch (e) {
      throw CacheException('Erro ao salvar cache de tarefas');
    }
  }

  @override
  Future<List<TodoModel>> getCachedTodos() async {
    try {
      final cached = _box.get(CacheKeys.todosKey);
      if (cached == null) return [];
      final list = List<Map>.from(cached as List);
      return list
          .map((map) => TodoModel.fromJson(Map<String, dynamic>.from(map)))
          .toList();
    } catch (e) {
      throw CacheException('Erro ao carregar cache local');
    }
  }
}
