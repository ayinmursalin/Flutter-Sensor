import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var dateTime = '';
  Timer? timer;

  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();

    initializeDateFormatting('id_ID', null).then((value) {
      dateFormat = DateFormat('dd MMMM yyyy, kk:mm:ss', 'id_ID');

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          dateTime = dateFormat.format(DateTime.now());
        });
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sensor'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(dateTime),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Click Me'),
          )
        ],
      ),
    );
  }
}
