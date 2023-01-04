import 'package:flutter/material.dart';

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
