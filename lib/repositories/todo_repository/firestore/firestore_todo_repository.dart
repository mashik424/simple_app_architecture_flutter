import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';

class FirestoreTodoRepository implements TodoRepository {
  FirestoreTodoRepository({FirebaseFirestore? firestore})
    : _collection = (firestore ?? FirebaseFirestore.instance).collection(
        'todos',
      );

  final CollectionReference<Map<String, dynamic>> _collection;

  @override
  Future<Todo> addTodo(String title) async {
    // Create the document reference first so its generated ID can be stored
    // as one of the document's fields.
    final docRef = _collection.doc();
    final now = DateTime.now();

    final todo = Todo(
      id: docRef.id,
      title: title,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    await docRef.set(todo.toJson());

    return todo;
  }

  @override
  Future<List<Todo>> addTodos(List<String> titles) =>
      Future.wait(titles.map(addTodo));

  @override
  Future<void> clearAllTodos() async {
    final snapshot = await _collection.get();
    final batch = _collection.firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    final snapshot = await _collection.orderBy('created_at').get();

    return [for (final doc in snapshot.docs) Todo.fromJson(doc.data())];
  }

  @override
  Future<Todo> getTodo(String id) async {
    final snapshot = await _collection.doc(id).get();
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Could not find a todo with id "$id"');
    }
    return Todo.fromJson(data);
  }

  @override
  Future<void> removeTodo(String id) => _collection.doc(id).delete();

  @override
  Future<Todo> updateTodo(Todo todo) async {
    final updated = todo.copyWith(updatedAt: DateTime.now());
    await _collection.doc(todo.id).set(updated.toJson());
    return updated;
  }
}
