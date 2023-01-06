import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ImagePreviewPage extends StatefulWidget {
  static const route = '/image-preview';

  const ImagePreviewPage({Key? key}) : super(key: key);

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  ImagePreviewArgs? args;

  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();

    _setupDateTime();
  }

  void _setupDateTime() {
    initializeDateFormatting('id_ID', null).then((value) {
      setState(() {
        dateFormat = DateFormat('dd MMMM yyyy, kk:mm:ss', 'id_ID');
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      args = ModalRoute.of(context)?.settings.arguments as ImagePreviewArgs?;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (args != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              Image.file(File(args!.filePath)),
              Container(
                margin: const EdgeInsets.only(top: 80, left: 16),
                padding: const EdgeInsets.all(16),
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Position',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Latitude: ${args?.position?.latitude}',
                      style:
                      const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Longitude: ${args?.position?.longitude}',
                      style:
                      const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Magnetometer',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'X: ${args?.magnetometer?.x}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Y: ${args?.magnetometer?.y}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Z: ${args?.magnetometer?.z}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dateFormat.format(args?.createdAt ?? DateTime.now()),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container();
  }
}

class ImagePreviewArgs {
  final String filePath;
  final DateTime createdAt;
  final Position? position;
  final MagnetometerEvent? magnetometer;

  ImagePreviewArgs({
    required this.filePath,
    required this.createdAt,
    this.position,
    this.magnetometer,
  });
}
