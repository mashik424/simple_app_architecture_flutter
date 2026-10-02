import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/main.dart';
import 'package:todoist/repositories/todo_repository/local/local_todo_repository.dart';

void main() {
  testWidgets('splash leads to the list where todos can be managed', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final repository = LocalTodoRepository(
      sharedPreferences: await SharedPreferences.getInstance(),
    );

    await tester.pumpWidget(MyApp(todoRepository: repository));
    expect(find.text('TODOIST'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('No todos yet. Add one!'), findsOneWidget);

    // Add a todo.
    await tester.tap(find.byTooltip('Add Todo'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  Buy milk  ');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.text('1/1'), findsOneWidget);

    // Complete it.
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect(find.text('0/1'), findsOneWidget);

    // Rename it.
    await tester.tap(find.text('Buy milk'));
    await tester.pumpAndSettle();
    expect(find.text('Edit Todo'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Buy oat milk');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Buy oat milk'), findsOneWidget);

    // Delete it.
    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('No todos yet. Add one!'), findsOneWidget);
    expect(await repository.getAllTodos(), isEmpty);
  });
}
