import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_infornet/presentation/components/error_state_components.dart';
import 'package:todo_infornet/presentation/components/offline_banner_components.dart';

import '../../core/theme/design_system.dart';
import '../controllers/auth_controller.dart';
import '../controllers/todo_controller.dart';
import '../widgets/todo_item_widget.dart';
import '../../routes.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoController controller = Get.find();
  late final AuthController? authController;

  @override
  void initState() {
    super.initState();
    authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : null;
    _ensureLoggedIn();
    if (controller.todos.isEmpty && !controller.isLoading.value) {
      // Garante exibição de loading até a primeira listagem carregar.
      controller.fetchTodos();
    }
  }

  void _ensureLoggedIn() {
    if (authController != null && !(authController?.isLoggedIn ?? true)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se perder sessão durante a vida útil da página (ex.: logout em outro local), volta ao login.
    if (authController != null && !(authController?.isLoggedIn ?? true)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(Routes.login);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primary,
          ),
        ),
        title: const Text(
          'To-Do List',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
        actionsIconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController?.logout,
            tooltip: 'Sair',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshTodos,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value != null) {
          return ErrorState(
            message: controller.errorMessage.value!,
            onRetry: controller.fetchTodos,
          );
        }

        if (controller.todos.isEmpty) {
          return const Center(child: Text('Nenhuma tarefa encontrada.'));
        }

        return Column(
          children: [
            if (controller.isOffline.value) const OfflineBanner(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshTodos,
                child: ListView.builder(
                  itemCount: controller.todos.length,
                  itemBuilder: (context, index) {
                    final todo = controller.todos[index];
                    return TodoItemWidget(todo: todo);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
