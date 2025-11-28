import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_infornet/data/datasources/local/todo_local_datasource.dart';
import 'package:todo_infornet/data/datasources/remote/auth_remote_datasource.dart';
import 'package:todo_infornet/data/datasources/remote/todo_remote_datasource.dart';
import 'package:todo_infornet/data/models/todo_model.dart';
import 'package:todo_infornet/data/repositories/todo_repository_impl.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockTodoRemoteDataSource extends Mock implements TodoRemoteDataSource {}

class _MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl repository;
  late _MockAuthRemoteDataSource authRemoteDataSource;
  late _MockTodoRemoteDataSource todoRemoteDataSource;
  late _MockTodoLocalDataSource todoLocalDataSource;

  const mockTodos = [
    TodoModel(id: 1, title: 'Teste 1', completed: false),
    TodoModel(id: 2, title: 'Teste 2', completed: true),
  ];

  setUp(() {
    authRemoteDataSource = _MockAuthRemoteDataSource();
    todoRemoteDataSource = _MockTodoRemoteDataSource();
    todoLocalDataSource = _MockTodoLocalDataSource();

    repository = TodoRepositoryImpl(
      authRemoteDataSource: authRemoteDataSource,
      todoRemoteDataSource: todoRemoteDataSource,
      todoLocalDataSource: todoLocalDataSource,
    );
  });

  test('online: busca remoto, cacheia e retorna lista', () async {
    when(
      () => authRemoteDataSource.authenticate(
        login: any(named: 'login'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => 'token');
    when(() => todoRemoteDataSource.getTodos('token')).thenAnswer((_) async => mockTodos);
    when(() => todoLocalDataSource.cacheTodos(mockTodos)).thenAnswer((_) async {});

    final result = await repository.getTodos(isConnected: true);

    expect(result, equals(mockTodos));
    verify(
      () => authRemoteDataSource.authenticate(
        login: any(named: 'login'),
        password: any(named: 'password'),
      ),
    ).called(1);
    verify(() => todoRemoteDataSource.getTodos('token')).called(1);
    verify(() => todoLocalDataSource.cacheTodos(mockTodos)).called(1);
    verifyNever(() => todoLocalDataSource.getCachedTodos());
  });

  test('offline: retorna dados do cache e nao chama remoto', () async {
    when(() => todoLocalDataSource.getCachedTodos()).thenAnswer((_) async => mockTodos);

    final result = await repository.getTodos(isConnected: false);

    expect(result, equals(mockTodos));
    verifyNever(
      () => authRemoteDataSource.authenticate(
        login: any(named: 'login'),
        password: any(named: 'password'),
      ),
    );
    verifyNever(() => todoRemoteDataSource.getTodos(any()));
    verify(() => todoLocalDataSource.getCachedTodos()).called(1);
  });
}
