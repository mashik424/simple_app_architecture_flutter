import 'package:flutter/material.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';

class TodosProvider with ChangeNotifier {
  TodosProvider({
    required TodoRepository repository,
  }) : _repository = repository {
    _initTodos();
  }

  final List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<void> _initTodos() async {
    _todos.addAll(await _repository.getAllTodos());
    notifyListeners();
  }

  final TodoRepository _repository;

  Future<void> addTodo(String title) async {
    final todo = await _repository.addTodo(title);
    _todos.add(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) async {
    final updated = await _repository.updateTodo(todo);
    final index = _todos.indexWhere((e) => e.id == todo.id);
    if (index < 0) return;
    _todos[index] = updated;
    notifyListeners();
  }

  void deleteTodo(String id) async {
    await _repository.removeTodo(id);
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}
