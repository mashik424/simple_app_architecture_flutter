import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';
import 'package:uuid/uuid.dart';

const _todosKey = 'todos';

class LocalTodoRepository implements TodoRepository {
  LocalTodoRepository({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;
  static const _uuid = Uuid();

  @override
  Future<Todo> addTodo(String title) async {
    final [todo] = await addTodos([title]);
    return todo;
  }

  @override
  Future<List<Todo>> addTodos(List<String> titles) async {
    final now = DateTime.now();
    final newTodos = [
      for (final title in titles)
        Todo(
          id: _uuid.v4(),
          title: title,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
    ];

    await _saveTodoList([...await getAllTodos(), ...newTodos]);

    return newTodos;
  }

  @override
  Future<void> clearAllTodos() => _sharedPreferences.remove(_todosKey);

  @override
  Future<List<Todo>> getAllTodos() async {
    final list = _sharedPreferences.getStringList(_todosKey) ?? const [];

    return [
      for (final e in list)
        Todo.fromJson(json.decode(e) as Map<String, dynamic>),
    ];
  }

  @override
  Future<Todo> getTodo(String id) async {
    final todos = await getAllTodos();
    for (final todo in todos) {
      if (todo.id == id) return todo;
    }
    throw StateError('Could not find a todo with id "$id"');
  }

  @override
  Future<void> removeTodo(String id) async {
    final allTodos = await getAllTodos()
      ..removeWhere((todo) => todo.id == id);

    await _saveTodoList(allTodos);
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final allTodos = await getAllTodos();

    final index = allTodos.indexWhere((e) => e.id == todo.id);

    if (index < 0) {
      throw StateError('Could not find a todo with id "${todo.id}"');
    }

    final updated = todo.copyWith(updatedAt: DateTime.now());
    allTodos[index] = updated;

    await _saveTodoList(allTodos);

    return updated;
  }

  Future<void> _saveTodoList(List<Todo> list) async {
    final stringList = [for (final todo in list) json.encode(todo.toJson())];
    await _sharedPreferences.setStringList(_todosKey, stringList);
  }
}
