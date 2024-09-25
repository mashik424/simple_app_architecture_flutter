import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';

class FirestoreTodoRepository implements TodoRepository {
  final _collection = FirebaseFirestore.instance.collection('todos');

  @override
  Future<Todo> addTodo(String title) async {
    // Create a new document reference in the 'users' collection
    DocumentReference docRef = _collection.doc();

    // Get the document ID
    String docId = docRef.id;

    final todo = Todo(
      id: docId,
      title: title,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add the document with the ID as one of its fields
    // await docRef.set(todo.copyWith(id: docId).toJson());
    await docRef.set(todo.toJson());

    return todo;
  }

  @override
  Future<List<Todo>> addTodos(List<String> titles) async {
    List<Todo> todos = [];
    for (final title in titles) {
      final todo = await addTodo(title);
      todos.add(todo);
    }

    return todos;
  }

  @override
  Future<void> clearAllTodos(String id) async {
    await _collection.get().then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    final snapshot = await _collection.get();

    return snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList();
  }

  @override
  Future<Todo> getTodo(String id) async {
    final snapshot = await _collection.doc(id).get();
    final data = snapshot.data();
    if (data != null) {
      return Todo.fromJson(data);
    } else {
      throw Exception('Could not find an item with the given id');
    }
  }

  @override
  Future<void> removeTodo(String id) async {
    final snapshot = await _collection.doc(id).get();
    await snapshot.reference.delete();
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    var snapshot = await _collection.doc(todo.id).get();

    await snapshot.reference.set(todo.toJson());

    snapshot = await snapshot.reference.get();

    return Todo.fromJson(snapshot.data()!);
  }
}
