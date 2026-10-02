import 'package:flutter_test/flutter_test.dart';
import 'package:todoist/models/todo.dart';

void main() {
  final todo = Todo(
    id: '1',
    title: 'Buy milk',
    isCompleted: false,
    createdAt: DateTime.utc(2024, 1, 1),
    updatedAt: DateTime.utc(2024, 1, 2),
  );

  test('round-trips through JSON', () {
    expect(Todo.fromJson(todo.toJson()), todo);
  });

  test('defaults is_completed to false when missing', () {
    final json = todo.toJson()..remove('is_completed');
    expect(Todo.fromJson(json).isCompleted, isFalse);
  });

  test('copyWith only replaces the given fields', () {
    final copy = todo.copyWith(isCompleted: true);
    expect(copy.isCompleted, isTrue);
    expect(copy.copyWith(isCompleted: false), todo);
  });
}
