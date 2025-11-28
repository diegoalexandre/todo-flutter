import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../core/network/network_info.dart';
import '../core/utils/constants.dart';
import '../data/datasources/local/todo_local_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/datasources/remote/todo_remote_datasource.dart';
import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/usecases/get_todos_usecase.dart';
import '../domain/usecases/sync_todos_usecase.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/todo_controller.dart';

class AppBinding extends Bindings {
  AppBinding(this.todosBox);

  final Box todosBox;

  @override
  void dependencies() {
    Get.put<Box>(todosBox, permanent: true);

    Get.lazyPut(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
      fenix: true,
    );

    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Connectivity()), fenix: true);

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<TodoRemoteDataSource>(
      () => TodoRemoteDataSourceImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut<TodoLocalDataSource>(
      () => TodoLocalDataSourceImpl(Get.find<Box>()),
      fenix: true,
    );

    Get.lazyPut<TodoRepository>(
      () => TodoRepositoryImpl(
        authRemoteDataSource: Get.find(),
        todoRemoteDataSource: Get.find(),
        todoLocalDataSource: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(() => GetTodosUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => SyncTodosUsecase(Get.find()), fenix: true);

    Get.lazyPut(
      () => TodoController(
        getTodosUsecase: Get.find(),
        syncTodosUsecase: Get.find(),
        networkInfo: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => AuthController(
        authRemoteDataSource: Get.find(),
        todosBox: Get.find(),
        todoController: Get.find(),
      ),
      fenix: true,
    );
  }
}
