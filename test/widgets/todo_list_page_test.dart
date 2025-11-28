import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_infornet/domain/entities/todo_entity.dart';
import 'package:todo_infornet/domain/usecases/get_todos_usecase.dart';
import 'package:todo_infornet/domain/usecases/sync_todos_usecase.dart';
import 'package:todo_infornet/presentation/controllers/todo_controller.dart';
import 'package:todo_infornet/presentation/pages/todo_list_page.dart';

import 'package:todo_infornet/core/network/network_info.dart';

class _MockGetTodosUsecase extends Mock implements GetTodosUsecase {}

class _MockSyncTodosUsecase extends Mock implements SyncTodosUsecase {}

class _FakeNetworkInfo implements NetworkInfo {
  _FakeNetworkInfo({this.connected = true});

  bool connected;

  @override
  Future<bool> get isConnected async => connected;
}

void main() {
  late TodoController controller;
  late _MockGetTodosUsecase getTodosUsecase;
  late _MockSyncTodosUsecase syncTodosUsecase;
  late _FakeNetworkInfo networkInfo;

  setUp(() {
    Get.testMode = true;
    getTodosUsecase = _MockGetTodosUsecase();
    syncTodosUsecase = _MockSyncTodosUsecase();
    networkInfo = _FakeNetworkInfo();
    controller = TodoController(
      getTodosUsecase: getTodosUsecase,
      syncTodosUsecase: syncTodosUsecase,
      networkInfo: networkInfo,
    );
    Get.put<TodoController>(controller);
  });

  tearDown(Get.reset);

  testWidgets('renderiza lista de tarefas', (tester) async {
    controller.todos.assignAll(const [
      TodoEntity(id: 1, title: 'Item 1', completed: false),
      TodoEntity(id: 2, title: 'Item 2', completed: true),
    ]);

    await tester.pumpWidget(const GetMaterialApp(home: TodoListPage()));
    await tester.pumpAndSettle();

    expect(find.text('Item 1'), findsOneWidget);
    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Pendente'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
  });

  testWidgets('mostra indicador de carregamento', (tester) async {
    controller.isLoading.value = true;

    await tester.pumpWidget(const GetMaterialApp(home: TodoListPage()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
