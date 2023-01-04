import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensor/ui/widgets/sensor_chart_view.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorChartPage extends StatefulWidget {
  static const route = '/charts';

  const SensorChartPage({Key? key}) : super(key: key);

  @override
  State<SensorChartPage> createState() => _SensorChartPageState();
}

class _SensorChartPageState extends State<SensorChartPage> {

  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyrometerSubscription;
  StreamSubscription? _magnetometerSubscription;

  final List<FlSpot> accelerometerXSpots = [const FlSpot(0, 0)];
  final List<FlSpot> accelerometerYSpots = [const FlSpot(0, 0)];
  final List<FlSpot> accelerometerZSpots = [const FlSpot(0, 0)];

  final List<FlSpot> gyrometerXSpots = [const FlSpot(0, 0)];
  final List<FlSpot> gyrometerYSpots = [const FlSpot(0, 0)];
  final List<FlSpot> gyrometerZSpots = [const FlSpot(0, 0)];

  final List<FlSpot> magnetometerXSpots = [const FlSpot(0, 0)];
  final List<FlSpot> magnetometerYSpots = [const FlSpot(0, 0)];
  final List<FlSpot> magnetometerZSpots = [const FlSpot(0, 0)];

  double accelerometerTick = 1;
  double gyrometerTick = 1;
  double magnetometerTick = 1;

  double spotLimit = 100;

  @override
  void initState() {
    super.initState();

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      if (accelerometerXSpots.length > spotLimit) {
        accelerometerXSpots.removeAt(0);
        accelerometerYSpots.removeAt(0);
        accelerometerZSpots.removeAt(0);
      }

      setState(() {
        accelerometerXSpots.add(FlSpot(accelerometerTick, event.x));
        accelerometerYSpots.add(FlSpot(accelerometerTick, event.y));
        accelerometerZSpots.add(FlSpot(accelerometerTick, event.z));
      });

      accelerometerTick++;
    });

    _gyrometerSubscription = gyroscopeEvents.listen((event) {
      if (gyrometerXSpots.length > spotLimit) {
        gyrometerXSpots.removeAt(0);
        gyrometerYSpots.removeAt(0);
        gyrometerZSpots.removeAt(0);
      }

      setState(() {
        gyrometerXSpots.add(FlSpot(gyrometerTick, event.x));
        gyrometerYSpots.add(FlSpot(gyrometerTick, event.y));
        gyrometerZSpots.add(FlSpot(gyrometerTick, event.z));
      });

      gyrometerTick++;
    });

    _magnetometerSubscription = magnetometerEvents.listen((event) {
      if (magnetometerXSpots.length > spotLimit) {
        magnetometerXSpots.removeAt(0);
        magnetometerYSpots.removeAt(0);
        magnetometerZSpots.removeAt(0);
      }

      setState(() {
        magnetometerXSpots.add(FlSpot(magnetometerTick, event.x));
        magnetometerYSpots.add(FlSpot(magnetometerTick, event.y));
        magnetometerZSpots.add(FlSpot(magnetometerTick, event.z));
      });

      magnetometerTick++;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;

    _gyrometerSubscription?.cancel();
    _gyrometerSubscription = null;

    _magnetometerSubscription?.cancel();
    _magnetometerSubscription = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Chart'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: SensorChartView(
                title: 'Accelerometer',
                xSpots: accelerometerXSpots,
                ySpots: accelerometerYSpots,
                zSpots: accelerometerZSpots,
                minY: -10,
                maxY: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: SensorChartView(
                title: 'Gyrometer',
                xSpots: gyrometerXSpots,
                ySpots: gyrometerYSpots,
                zSpots: gyrometerZSpots,
                minY: -10,
                maxY: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: SensorChartView(
                title: 'Magnetometer',
                xSpots: magnetometerXSpots,
                ySpots: magnetometerYSpots,
                zSpots: magnetometerZSpots,
                minY: -55,
                maxY: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
