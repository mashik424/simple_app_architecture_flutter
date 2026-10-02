import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/models/todo.dart';
import 'package:todoist/views/modals/add_todo_bs.dart';
import 'package:todoist/views/widgets/todo_list_item.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodosProvider>();
    final todos = provider.todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoist'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Text(
                '${provider.remainingCount}/${todos.length}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
      body: switch ((provider.isLoading, todos.isEmpty)) {
        (true, _) => const Center(child: CircularProgressIndicator()),
        (false, true) => const Center(child: Text('No todos yet. Add one!')),
        _ => ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return TodoListItem(
              key: ValueKey(todo.id),
              todo: todo,
              onTap: () => _openAddTodoBS(context, todo: todo),
              onCheckboxChanged: (_) => provider.toggleTodo(todo),
              onDeletePressed: provider.deleteTodo,
            );
          },
        ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTodoBS(context),
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openAddTodoBS(BuildContext context, {Todo? todo}) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => AddTodoBS(todo: todo),
      );
}
