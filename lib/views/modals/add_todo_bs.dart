import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/models/todo.dart';

class AddTodoBS extends StatefulWidget {
  const AddTodoBS({
    this.todo,
    super.key,
  });

  final Todo? todo;

  @override
  State<AddTodoBS> createState() => _AddTodoBSState();
}

class _AddTodoBSState extends State<AddTodoBS> {
  final _textEditingController = TextEditingController();
  @override
  void initState() {
    _textEditingController.text = widget.todo?.title ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodosProvider>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Builder(builder: (context) {
              return Text(
                'Add a Todo',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            }),
            const SizedBox(height: 24),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Title',
                label: Text('Title'),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_textEditingController.text.isEmpty) {
                  return;
                }
                if (widget.todo == null) {
                  value.addTodo(_textEditingController.text);
                } else {
                  value.updateTodo(
                    widget.todo!.copyWith(
                      title: _textEditingController.text,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }
}