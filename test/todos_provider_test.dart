import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/repositories/todo_repository/local/local_todo_repository.dart';

void main() {
  late LocalTodoRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = LocalTodoRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  });

  Future<TodosProvider> createLoadedProvider() async {
    final provider = TodosProvider(repository: repository);
    await pumpEventQueue();
    return provider;
  }

  test('loads existing todos from the repository', () async {
    await repository.addTodos(['A', 'B']);

    final provider = TodosProvider(repository: repository);
    expect(provider.isLoading, isTrue);

    await pumpEventQueue();
    expect(provider.isLoading, isFalse);
    expect(provider.todos.map((t) => t.title), ['A', 'B']);
  });

  test('adds, toggles and deletes todos', () async {
    final provider = await createLoadedProvider();
    var notifications = 0;
    provider.addListener(() => notifications++);

    await provider.addTodo('A');
    expect(provider.todos.single.title, 'A');
    expect(provider.remainingCount, 1);

    await provider.toggleTodo(provider.todos.single);
    expect(provider.todos.single.isCompleted, isTrue);
    expect(provider.remainingCount, 0);

    await provider.deleteTodo(provider.todos.single.id);
    expect(provider.todos, isEmpty);
    expect(await repository.getAllTodos(), isEmpty);

    expect(notifications, 3);
  });
}
