import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sensor'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text('Test 123'),
            ElevatedButton(onPressed: () {}, child: Text('Click Me'))
          ],
        ),
      ),
    );
  }
}
