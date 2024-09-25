import 'package:flutter/material.dart';
import 'package:todoist/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    required this.todo,
    this.onTap,
    this.onCheckboxChanged,
    this.onDeletePressed,
    super.key,
  });

  final Todo todo;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckboxChanged;
  final ValueChanged<String>? onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(todo.title),
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: onCheckboxChanged,
      ),
      trailing: IconButton(
        onPressed: () => onDeletePressed?.call(todo.id),
        icon: const Icon(Icons.delete),
      ),
    );
  }
}