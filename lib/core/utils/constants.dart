import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      (dotenv.isInitialized ? dotenv.env['API_BASE_URL'] : null) ?? 'http://lf.infornet.com.br:3010';
  static const authPath = '/auth';
  static const todosPath = '/todos';

  static const loginHeader = 'x-login';
  static const passwordHeader = 'x-senha';
  static String get loginValue =>
      (dotenv.isInitialized ? dotenv.env['API_LOGIN'] : null) ?? 'testeFlutter';
  static String get passwordValue =>
      (dotenv.isInitialized ? dotenv.env['API_PASSWORD'] : null) ?? '#Qsy&_@73bh';
}

class CacheKeys {
  static const todosBox = 'todos_box';
  static const todosKey = 'todos';
  static const tokenKey = 'auth_token';
}
