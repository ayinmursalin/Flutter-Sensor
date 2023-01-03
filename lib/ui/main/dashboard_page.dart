import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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
  var dateTime = '';
  Timer? timer;

  late DateFormat dateFormat;
  final Battery battery = Battery();
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
  );
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool hasLocationPermission = false;

  String deviceName = '';
  String deviceModel = '';
  String osVersion = '';

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

    Geolocator.checkPermission().then((permission) {
      setState(() {
        hasLocationPermission = permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse;
      });
    });

    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((value) {
        setState(() {
          deviceName = value.brand;
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
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
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
          ],
        ),
      ),
    );
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

class DeviceInfoView extends StatelessWidget {
  final String deviceName;
  final String deviceModel;
  final String osVersion;

  const DeviceInfoView({
    Key? key,
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Device Info',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('Device: $deviceName'),
        Text('Model: $deviceModel'),
        Text('OS Version: $osVersion')
      ],
    );
  }
}

class SensorInfoView extends StatelessWidget {
  final String title;
  final double x;
  final double y;
  final double z;

  const SensorInfoView({
    Key? key,
    required this.title,
    required this.x,
    required this.y,
    required this.z,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'X: ${x.toStringAsFixed(6)}',
              style: const TextStyle(color: Colors.red),
            ),
            Text(
              'Y: ${y.toStringAsFixed(6)}',
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              'Z: ${z.toStringAsFixed(6)}',
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        )
      ],
    );
  }
}

class BatteryLevelView extends StatelessWidget {
  final BatteryState state;
  final int percentage;

  const BatteryLevelView({
    Key? key,
    required this.state,
    required this.percentage,
  }) : super(key: key);

  final double width = 240;

  @override
  Widget build(BuildContext context) {
    var icon = Icons.electric_bolt_rounded;
    if (state == BatteryState.full) {
      icon = Icons.battery_charging_full_rounded;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Battery Level',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 240,
          height: 80,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: state == BatteryState.charging ||
                          state == BatteryState.full,
                      child: Icon(
                        icon,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '$percentage %',
                      style: TextStyle(
                        fontSize: 32,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class GeolocationView extends StatelessWidget {
  final double latitude;
  final double longitude;

  const GeolocationView({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Location',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Latitude: $latitude'),
              Text('Longitude: $longitude'),
            ],
          ),
        ),
      ],
    );
  }
}
