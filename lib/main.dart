import 'package:flutter/material.dart';
import 'package:flutter_sensor/data/local/db/app_database.dart';
import 'package:flutter_sensor/data/local/db/db_helper.dart';
import 'package:flutter_sensor/ui/auth/login_page.dart';
import 'package:flutter_sensor/ui/auth/register_page.dart';
import 'package:flutter_sensor/ui/main/dashboard_page.dart';
import 'package:flutter_sensor/ui/main/todo_list_page.dart';
import 'package:provider/provider.dart';

import 'color_schemes.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase appDatabase = await DbHelper.initializeDatabase();

  runApp(MyApp(appDatabase: appDatabase));
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase;

  const MyApp({
    super.key,
    required this.appDatabase,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => appDatabase),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        initialRoute: LoginPage.route,
        debugShowCheckedModeBanner: false,
        routes: {
          LoginPage.route: (ctx) => const LoginPage(),
          RegisterPage.route: (ctx) => const RegisterPage(),
          HomePage.route: (ctx) => const HomePage(),
          TodoListPage.route: (ctx) => const TodoListPage(),
        },
      ),
    );
  }
}
