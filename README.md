# To-Do Infornet Teste técnico

Aplicativo Flutter offline-first que autentica em uma API REST, busca a lista de tarefas e mantem um cache local para uso sem internet. Usa Clean Architecture, GetX para estado/navegacao/DI e Hive para persistencia.

## Requisitos
- Flutter 3.24+
- Dart 3.8+

## Para rodar o To-do Infornet
1. Instale as dependências: `flutter pub get`
2. Caso limpar o cache do dart, para configurar o icone e splashscreen: `dart run flutter_native_splash:create`  e  `dart run flutter_launcher_icons`
3. Rode o app: `flutter run`

## Como testar tudo
- `flutter test`

## Arquitetura
- **core**: utilidades, verificacao de rede, excecoes.
- **data**: models, datasources remotos (auth, todos) e local (Hive), repositorio concreto.
- **domain**: entidades, repositorio abstrato, usecases (`GetTodosUsecase`, `SyncTodosUsecase`).
- **presentation**: controllers GetX, paginas (`SplashPage`, `TodoListPage`) e widgets.
- **di**: binding GetX com todas as dependencias.

## Offline-first
- Na inicializacao, verifica conexao; se online autentica, busca tarefas e atualiza o cache Hive. Se offline, carrega apenas do cache.
- Botao de atualizar segue a mesma regra: online = busca + cache; offline = recarrega cache e avisa o usuario.
- Cache armazenado em Hive (`todos_box`) sem necessidade de modelos registrados.
