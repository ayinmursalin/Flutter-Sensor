import 'package:flutter/material.dart';
import 'package:flutter_sensor/ui/auth/login_page.dart';
import 'package:flutter_sensor/ui/auth/register_page.dart';
import 'package:flutter_sensor/ui/main/dashboard_page.dart';

import 'color_schemes.g.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        initialRoute: LoginPage.route,
        debugShowCheckedModeBanner: false,
        routes: {
          LoginPage.route: (ctx) => const LoginPage(),
          RegisterPage.route: (ctx) => const RegisterPage(),
          HomePage.route: (ctx) => const HomePage(),
        },
    );
  }
}
