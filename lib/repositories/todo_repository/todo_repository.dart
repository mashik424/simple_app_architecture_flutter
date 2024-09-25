import 'package:todoist/models/todo.dart';

abstract class TodoRepository {
  Future<Todo> addTodo(String title);

  Future<List<Todo>> addTodos(List<String> titles);

  Future<Todo> updateTodo(Todo todo);

  Future<void> removeTodo(String id);

  Future<void> clearAllTodos(String id);

  Future<List<Todo>> getAllTodos();

  Future<Todo> getTodo(String id);
}
