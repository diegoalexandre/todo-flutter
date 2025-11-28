import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/utils/constants.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../routes.dart';
import 'todo_controller.dart';

class AuthController extends GetxController {
  AuthController({
    required this.authRemoteDataSource,
    required this.todosBox,
    required this.todoController,
  });

  final AuthRemoteDataSource authRemoteDataSource;
  final Box todosBox;
  final TodoController todoController;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final RxnString token = RxnString();

  bool get isLoggedIn => token.value != null && token.value!.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    final storedToken = todosBox.get(CacheKeys.tokenKey);
    if (storedToken != null) {
      token.value = storedToken.toString();
    }
  }

  Future<void> login({
    required String login,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await authRemoteDataSource.authenticate(
        login: login,
        password: password,
      );
      token.value = result;
      await todosBox.put(CacheKeys.tokenKey, result);
      await todoController.fetchTodos();
      Get.offAllNamed(Routes.todoList);
    } catch (e) {
      errorMessage.value = _friendlyMessage(e);
      Get.snackbar('Erro', errorMessage.value ?? 'Falha no login');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    token.value = null;
    todoController.todos.clear();
    Get.closeAllSnackbars();
    // Navega imediatamente para o login sem exibir carregamento.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    });
    // Limpa cache em segundo plano para não travar a navegação.
    unawaited(todosBox.delete(CacheKeys.todosKey));
    unawaited(todosBox.delete(CacheKeys.tokenKey));
  }

  String _friendlyMessage(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    return 'Falha no login. Verifique suas credenciais ou conexão.';
  }
}
