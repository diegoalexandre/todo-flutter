import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'di/app_binding.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/todo_list_page.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key, required this.todosBox});

  final Box todosBox;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(todosBox),
      initialRoute: Routes.splash,
      getPages: [
        GetPage(
          name: Routes.login,
          page: () => const LoginPage(),
        ),
        GetPage(
          name: Routes.splash,
          page: () => const SplashPage(),
        ),
        GetPage(
          name: Routes.todoList,
          page: () => const TodoListPage(),
        ),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
    );
  }
}
