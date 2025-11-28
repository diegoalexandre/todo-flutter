import 'package:dio/dio.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/utils/constants.dart';

abstract class AuthRemoteDataSource {
  Future<String> authenticate({required String login, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._client);

  final Dio _client;

  @override
  Future<String> authenticate({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        ApiConstants.authPath,
        options: Options(
          headers: {
            ApiConstants.loginHeader: login,
            ApiConstants.passwordHeader: password,
          },
        ),
      );

      final token = response.data['token'];
      if (token == null) {
        throw const AuthException('Token nao encontrado na resposta');
      }
      return token.toString();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AuthException('Usuário ou senha inválidos');
      }
      throw AuthException('Falha na autenticacao: ${e.message}');
    }
  }
}
