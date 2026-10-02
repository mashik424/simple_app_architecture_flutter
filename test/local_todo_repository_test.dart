import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/repositories/todo_repository/local/local_todo_repository.dart';

void main() {
  late LocalTodoRepository repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = LocalTodoRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );
  });

  test('starts empty', () async {
    expect(await repository.getAllTodos(), isEmpty);
  });

  test('adds and reads todos', () async {
    final todo = await repository.addTodo('First');
    await repository.addTodos(['Second', 'Third']);

    final all = await repository.getAllTodos();
    expect(all.map((t) => t.title), ['First', 'Second', 'Third']);
    expect(all.map((t) => t.id).toSet(), hasLength(3));
    expect(await repository.getTodo(todo.id), todo);
  });

  test('updates a todo and bumps updatedAt', () async {
    final todo = await repository.addTodo('First');
    final updated = await repository.updateTodo(
      todo.copyWith(title: 'Renamed', isCompleted: true),
    );

    expect(updated.title, 'Renamed');
    expect(updated.isCompleted, isTrue);
    expect(updated.updatedAt.isBefore(todo.updatedAt), isFalse);
    expect(await repository.getTodo(todo.id), updated);
  });

  test('throws when updating or getting an unknown todo', () async {
    final todo = await repository.addTodo('First');
    await repository.removeTodo(todo.id);

    expect(() => repository.updateTodo(todo), throwsStateError);
    expect(() => repository.getTodo(todo.id), throwsStateError);
  });

  test('removes and clears todos', () async {
    final todo = await repository.addTodo('First');
    await repository.addTodo('Second');

    await repository.removeTodo(todo.id);
    expect((await repository.getAllTodos()).single.title, 'Second');

    await repository.clearAllTodos();
    expect(await repository.getAllTodos(), isEmpty);
  });
}
