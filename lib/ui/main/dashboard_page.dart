import 'dart:async';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensor/ui/main/todo_list_page.dart';
import 'package:flutter_sensor/ui/widgets/battery_level_view.dart';
import 'package:flutter_sensor/ui/widgets/device_info_view.dart';
import 'package:flutter_sensor/ui/widgets/geolocation_view.dart';
import 'package:flutter_sensor/ui/widgets/sensor_info_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomePage extends StatefulWidget {
  static const route = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Battery battery = Battery();
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
  );
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  late DateFormat dateFormat;

  Timer? timer;

  String dateTime = '';
  String deviceName = '';
  String deviceModel = '';
  String osVersion = '';

  bool hasLocationPermission = false;

  int refreshRate = 1;

  @override
  void initState() {
    super.initState();

    _setupDateTime();
    _setupGeolocator();
    _setupDeviceInfo();
  }

  void _setupDateTime() {
    initializeDateFormatting('id_ID', null).then((value) {
      dateFormat = DateFormat('dd MMMM yyyy, kk:mm:ss', 'id_ID');

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          dateTime = dateFormat.format(DateTime.now());
        });
      });
    });
  }

  void _setupGeolocator() {
    Geolocator.checkPermission().then((permission) {
      setState(() {
        hasLocationPermission = permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
      });
    });
  }

  void _setupDeviceInfo() {
    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((value) {
        setState(() {
          deviceName = value.device;
          deviceModel = value.model;
          osVersion = value.version.release;
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
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) {
              return [
                const PopupMenuItem(
                  value: 0,
                  child: Text('Todo List'),
                ),
              ];
            },
            onSelected: _handlePopupMenu,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: DeviceInfoView(
                deviceName: deviceName,
                deviceModel: deviceModel,
                osVersion: osVersion,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: StreamBuilder(
                stream: accelerometerEvents,
                builder: (ctx, snapshot) {
                  return SensorInfoView(
                    title: 'Accelerometer',
                    x: snapshot.data?.x ?? 0.0,
                    y: snapshot.data?.y ?? 0.0,
                    z: snapshot.data?.z ?? 0.0,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: StreamBuilder(
                stream: gyroscopeEvents,
                builder: (ctx, snapshot) {
                  return SensorInfoView(
                    title: 'Gyroscope',
                    x: snapshot.data?.x ?? 0.0,
                    y: snapshot.data?.y ?? 0.0,
                    z: snapshot.data?.z ?? 0.0,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: StreamBuilder(
                stream: magnetometerEvents,
                builder: (ctx, snapshot) {
                  return SensorInfoView(
                    title: 'Magnetometer',
                    x: snapshot.data?.x ?? 0.0,
                    y: snapshot.data?.y ?? 0.0,
                    z: snapshot.data?.z ?? 0.0,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: hasLocationPermission
                  ? StreamBuilder(
                      stream: Geolocator.getPositionStream(
                        locationSettings: locationSettings,
                      ),
                      builder: (ctx, snapshot) {
                        return GeolocationView(
                          latitude: snapshot.data?.latitude ?? 0.0,
                          longitude: snapshot.data?.longitude ?? 0.0,
                        );
                      },
                    )
                  : ElevatedButton(
                      onPressed: _requestLocationPermission,
                      child: const Text('Enable Access Location'),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: StreamBuilder(
                stream: battery.onBatteryStateChanged,
                builder: (ctx, batteryState) {
                  return FutureBuilder(
                    future: battery.batteryLevel,
                    builder: (ctx, batteryLevel) {
                      return BatteryLevelView(
                        state: batteryState.data ?? BatteryState.unknown,
                        percentage: batteryLevel.data ?? 0,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePopupMenu(int selectedIndex) {
    switch(selectedIndex) {
      case 0:
        Navigator.pushNamed(context, TodoListPage.route);
        break;
      default:
    }
  }

  void _requestLocationPermission() {
    Geolocator.requestPermission().then((permission) {
      setState(() {
        hasLocationPermission = permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
      });
    });
  }
}
