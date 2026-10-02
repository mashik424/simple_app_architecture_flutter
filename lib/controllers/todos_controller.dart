import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';

class TodosProvider extends ChangeNotifier {
  TodosProvider({required TodoRepository repository})
    : _repository = repository {
    _initTodos();
  }

  final TodoRepository _repository;
  final List<Todo> _todos = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  int get remainingCount => _todos.where((todo) => !todo.isCompleted).length;

  Future<void> _initTodos() async {
    try {
      _todos.addAll(await _repository.getAllTodos());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) async {
    final todo = await _repository.addTodo(title);
    _todos.add(todo);
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    final updated = await _repository.updateTodo(todo);
    final index = _todos.indexWhere((e) => e.id == todo.id);
    if (index < 0) return;
    _todos[index] = updated;
    notifyListeners();
  }

  Future<void> toggleTodo(Todo todo) =>
      updateTodo(todo.copyWith(isCompleted: !todo.isCompleted));

  Future<void> deleteTodo(String id) async {
    await _repository.removeTodo(id);
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
