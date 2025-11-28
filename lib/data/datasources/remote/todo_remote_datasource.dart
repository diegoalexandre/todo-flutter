import 'package:dio/dio.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/utils/constants.dart';
import '../../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos(String token);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  TodoRemoteDataSourceImpl(this._client);

  final Dio _client;

  @override
  Future<List<TodoModel>> getTodos(String token) async {
    try {
      final response = await _client.get(
        ApiConstants.todosPath,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data is List) {
        final data = response.data as List;
        return TodoModel.fromList(data);
      }
      throw const ServerException('Resposta inesperada da API');
    } on DioException catch (e) {
      throw ServerException('Erro ao buscar tarefas: ${e.message}');
    }
  }
}
