import 'package:flutter/material.dart';

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
