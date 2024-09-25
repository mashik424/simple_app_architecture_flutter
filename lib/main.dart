import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoist/controllers/todos_controller.dart';
import 'package:todoist/firebase_options.dart';
import 'package:todoist/views/screens/splash_screen.dart';
import 'package:todoist/views/screens/todos_list_screen.dart';
import 'package:todoist/repositories/todo_repository/firestore/firestore_todo_repository.dart';
import 'package:todoist/repositories/todo_repository/local/local_todo_repository.dart';
import 'package:todoist/repositories/todo_repository/todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: prefs));
}

class MyApp extends StatefulWidget {
  const MyApp({required this.sharedPreferences, super.key});

  final SharedPreferences sharedPreferences;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TodoRepository todoRepository;

  @override
  void initState() {
    super.initState();
    // TODO(everyone): You can change the repository implementation here
    todoRepository = LocalTodoRepository(
      sharedPreferences: widget.sharedPreferences,
    );
    // todoRepository = FirestoreTodoRepository();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodosProvider(
        localStorageRepo: todoRepository,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );

            case 'todos':
              return MaterialPageRoute(
                builder: (context) => const TodoListScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: Text(
                      'Not route found',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
