import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://lf.infornet.com.br:3010';
  static const authPath = '/auth';
  static const todosPath = '/todos';

  static const loginHeader = 'x-login';
  static const passwordHeader = 'x-senha';
  static String get loginValue => dotenv.env['API_LOGIN'] ?? 'testeFlutter';
  static String get passwordValue => dotenv.env['API_PASSWORD'] ?? '#Qsy&_@73bh';
}

class CacheKeys {
  static const todosBox = 'todos_box';
  static const todosKey = 'todos';
  static const tokenKey = 'auth_token';
}
