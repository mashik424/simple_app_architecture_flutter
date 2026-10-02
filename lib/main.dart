import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/repositories/todo_repository/local/local_todo_repository.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';
import 'package:todoist/routes.dart';
import 'package:todoist/views/screens/splash_screen.dart';
import 'package:todoist/views/screens/todos_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(everyone): You can change the repository implementation here.
  // To use Firestore instead, configure Firebase with the FlutterFire CLI and:
  //
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   final todoRepository = FirestoreTodoRepository();
  final TodoRepository todoRepository = LocalTodoRepository(
    sharedPreferences: await SharedPreferences.getInstance(),
  );

  runApp(MyApp(todoRepository: todoRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.todoRepository, super.key});

  final TodoRepository todoRepository;

  static const _seedColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodosProvider(repository: todoRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todoist',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: _seedColor,
            brightness: Brightness.dark,
          ),
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: (settings) => switch (settings.name) {
          Routes.splash => MaterialPageRoute<void>(
            builder: (context) => const SplashScreen(),
          ),
          Routes.todos => MaterialPageRoute<void>(
            builder: (context) => const TodoListScreen(),
          ),
          _ => MaterialPageRoute<void>(
            builder: (context) => Scaffold(
              body: Center(
                child: Text(
                  'Route not found',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
            ),
          ),
        },
      ),
    );
  }
}
