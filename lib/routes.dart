// routes.dart
import 'package:get/get.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/todo_list_page.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const todoList = '/todo-list';
}

final List<GetPage> appPages = [
  GetPage(
    name: Routes.splash,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: Routes.todoList,
    page: () => const TodoListPage(),
  ),
];
