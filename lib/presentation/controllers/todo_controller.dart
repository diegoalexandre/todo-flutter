import 'package:get/get.dart';

import '../../core/network/network_info.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/sync_todos_usecase.dart';

class TodoController extends GetxController {
  TodoController({
    required this.getTodosUsecase,
    required this.syncTodosUsecase,
    required this.networkInfo,
  });

  final GetTodosUsecase getTodosUsecase;
  final SyncTodosUsecase syncTodosUsecase;
  final NetworkInfo networkInfo;

  final RxList<TodoEntity> todos = <TodoEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final RxBool isOffline = false.obs;

  Future<void> fetchTodos() async {
    await _handleTodosLoad(usecase: getTodosUsecase);
  }

  Future<void> refreshTodos() async {
    await _handleTodosLoad(usecase: syncTodosUsecase, triggeredByUser: true);
  }

  Future<void> _handleTodosLoad({
    required Future<List<TodoEntity>> Function({required bool isConnected}) usecase,
    bool triggeredByUser = false,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    var hasConnection = false;
    try {
      try {
        hasConnection = await networkInfo.isConnected;
        isOffline.value = !hasConnection;
      } catch (_) {
        // Se a checagem de rede falhar, assume offline para ler do cache.
        hasConnection = false;
        isOffline.value = true;
      }

      final result = await usecase(isConnected: hasConnection);
      todos.assignAll(result);
      if (triggeredByUser && !hasConnection) {
        Get.snackbar('Offline', 'Sem conexao. Exibindo dados em cache.');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      if (triggeredByUser) {
        Get.snackbar('Erro', errorMessage.value ?? 'Falha ao atualizar');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
