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
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      title: Text(
        todo.title,
        style: todo.isCompleted
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurfaceVariant,
              )
            : null,
      ),
      leading: Checkbox(value: todo.isCompleted, onChanged: onCheckboxChanged),
      trailing: IconButton(
        onPressed: () => onDeletePressed?.call(todo.id),
        tooltip: 'Delete',
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }
}
