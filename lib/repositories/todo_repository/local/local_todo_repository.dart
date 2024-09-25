import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';
import 'package:uuid/uuid.dart';

const _todos = 'todos';

class LocalTodoRepository implements TodoRepository {
  LocalTodoRepository({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  Future<Todo> addTodo(String title) async {
    final todo = Todo(
      id: const Uuid().v1(),
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _saveTodoList([...(await getAllTodos()), todo]);

    return todo;
  }

  @override
  Future<List<Todo>> addTodos(List<String> titles) async {
    const uuid = Uuid();
    final newTodos = titles
        .map(
          (title) => Todo(
            id: uuid.v1(),
            title: title,
            isCompleted: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )
        .toList();

    await _saveTodoList([...(await getAllTodos()), ...newTodos]);

    return newTodos;
  }

  @override
  Future<void> clearAllTodos(String id) async =>
      _sharedPreferences.setStringList(
        _todos,
        [],
      );

  @override
  Future<List<Todo>> getAllTodos() async {
    final list = _sharedPreferences.getStringList(_todos) ?? [];

    if (list.isEmpty) {
      return <Todo>[];
    }

    return list
        .map((e) => Todo.fromJson(json.decode(e) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Todo> getTodo(String id) async {
    return (await getAllTodos()).firstWhere(
      (todo) => todo.id == id,
    );
  }

  @override
  Future<void> removeTodo(String id) async {
    var allTodos = await getAllTodos();

    allTodos.removeWhere((todo) => todo.id == id);

    await _saveTodoList(allTodos);
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final allTodos = await getAllTodos();

    final index = allTodos.indexWhere((e) => e.id == todo.id);

    if (index < 0) {
      throw Exception('Could not find an item with the same id');
    }

    allTodos[index] = todo;

    await _saveTodoList(allTodos);

    return todo;
  }

  Future<void> _saveTodoList(List<Todo> list) async {
    final stringList = list.map((todo) => json.encode(todo.toJson())).toList();
    await _sharedPreferences.setStringList(_todos, stringList);
  }
}
