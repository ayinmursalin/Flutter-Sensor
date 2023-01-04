import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensor/data/local/db/app_database.dart';
import 'package:flutter_sensor/data/local/db/entities/todo_entity.dart';
import 'package:flutter_sensor/ui/widgets/device_info_view.dart';
import 'package:flutter_sensor/ui/widgets/qrcode_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  static const route = '/todo';

  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  late AppDatabase appDatabase;
  late DateFormat dateFormat;

  String deviceName = '';
  String deviceModel = '';
  String osVersion = '';
  String manufacturer = '';

  @override
  void initState() {
    super.initState();

    _setupDateTime();
    _setupDeviceInfo();
    appDatabase = Provider.of<AppDatabase>(context, listen: false);
  }

  void _setupDateTime() {
    initializeDateFormatting('id_ID', null).then((value) {
      dateFormat = DateFormat('dd MMMM yyyy, kk:mm:ss', 'id_ID');
    });
  }

  void _setupDeviceInfo() {
    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((value) {
        setState(() {
          deviceName = value.device;
          deviceModel = value.model;
          osVersion = value.version.release;
          manufacturer = value.manufacturer;
        });
      });
    } else if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo.then((value) {
        setState(() {
          deviceName = value.name ?? '';
          deviceModel = value.model ?? '';
          osVersion = value.systemVersion ?? '';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DeviceInfoView(
                deviceName: deviceName,
                deviceModel: deviceModel,
                osVersion: osVersion,
                manufacturer: manufacturer,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 24),
              child: Text(
                'Todo List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: StreamBuilder(
                stream: appDatabase.todoDao.getTodoList(),
                builder: (ctx, snapshot) {
                  var dataList = snapshot.data ?? [];

                  return dataList.isEmpty
                      ? const EmptyTodoListView()
                      : TodoListView(
                          dateFormat: dateFormat,
                          dataList: dataList,
                        );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTodo,
        tooltip: 'Create To Do',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  void _onAddTodo() async {
    var todo = await showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const CreateTodoView(),
        );
      },
    );

    await appDatabase.todoDao.insertTodo(TodoEntity(todo, DateTime.now()));
  }
}

class EmptyTodoListView extends StatelessWidget {
  const EmptyTodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          'Empty Todo List',
          style: TextStyle(
            fontSize: 24,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

class TodoListView extends StatelessWidget {
  final DateFormat dateFormat;
  final List<TodoEntity> dataList;

  const TodoListView({
    Key? key,
    required this.dateFormat,
    required this.dataList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dataList.length,
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (ctx, idx) {
        var data = dataList[idx];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${idx + 1}. ${data.label}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        dateFormat.format(data.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _onShowQr(context, data.label);
                  },
                  icon: const Icon(Icons.qr_code_2_rounded),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onShowQr(BuildContext context, String data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return QrCodeView(data: data);
      },
    );
  }
}

class CreateTodoView extends StatefulWidget {
  const CreateTodoView({Key? key}) : super(key: key);

  @override
  State<CreateTodoView> createState() => _CreateTodoViewState();
}

class _CreateTodoViewState extends State<CreateTodoView> {
  final todoEditing = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Text(
                'Create To Do',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: TextField(
                controller: todoEditing,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'To Do',
                  hintText: 'To Do',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (todoEditing.text.isEmpty) return;

                  Navigator.pop(context, todoEditing.text);
                },
                child: const Text('Create'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
