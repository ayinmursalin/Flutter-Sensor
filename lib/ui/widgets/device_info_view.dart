import 'package:flutter/material.dart';

class DeviceInfoView extends StatelessWidget {
  final String deviceName;
  final String deviceModel;
  final String osVersion;
  final String? manufacturer;

  const DeviceInfoView({
    Key? key,
    required this.deviceName,
    required this.deviceModel,
    required this.osVersion,
    this.manufacturer,
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
        Text('OS Version: $osVersion'),
        Visibility(
          visible: manufacturer != null,
          child: Text('Manufacturer: $manufacturer'),
        ),
      ],
    );
  }
}
