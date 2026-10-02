import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/models/todo.dart';

class AddTodoBS extends StatefulWidget {
  const AddTodoBS({this.todo, super.key});

  final Todo? todo;

  @override
  State<AddTodoBS> createState() => _AddTodoBSState();
}

class _AddTodoBSState extends State<AddTodoBS> {
  late final _textEditingController = TextEditingController(
    text: widget.todo?.title,
  );

  bool get _isEditing => widget.todo != null;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _textEditingController.text.trim();
    if (title.isEmpty) return;

    final provider = context.read<TodosProvider>();
    final todo = widget.todo;
    Navigator.of(context).pop();
    if (todo == null) {
      await provider.addTodo(title);
    } else {
      await provider.updateTodo(todo.copyWith(title: title));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Keep the sheet above the on-screen keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit Todo' : 'Add a Todo',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _textEditingController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
