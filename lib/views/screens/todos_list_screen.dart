import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/views/modals/add_todo_bs.dart';
import 'package:todoist/views/widgets/todo_list_item.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todoist'),
        actions: [
          Consumer<TodosProvider>(
            builder: (context, value, child) => Text(
              value.todos.length.toString(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: Consumer<TodosProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.todos.length,
          itemBuilder: (context, index) => TodoListItem(
            todo: provider.todos[index],
            onTap: () => _openAddToDoBS(context, todo: provider.todos[index]),
            onCheckboxChanged: (completed) => provider.updateTodo(
              provider.todos[index].copyWith(
                isCompleted: completed,
              ),
            ),
            onDeletePressed: (todoId) => provider.deleteTodo(todoId),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddToDoBS(context),
        tooltip: 'Add TODO',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openAddToDoBS(
    BuildContext context, {
    Todo? todo,
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => AddTodoBS(
        todo: todo,
      ),
    );
  }
}
