import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensor/ui/main/image_preview_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:intl/date_symbol_data_local.dart';

class CameraPage extends StatefulWidget {
  static const route = '/camera';

  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
  );

  CameraController? _cameraController;

  bool hasLocationPermission = false;
  bool isInfoShow = false;

  late DateFormat dateFormat;
  Timer? timer;

  Position? lastPosition;
  MagnetometerEvent? lastMagnetometer;
  String dateTime = '';

  @override
  void initState() {
    super.initState();

    _setupDateTime();
    _setupGeolocator();

    availableCameras().then((cameraDescriptions) {
      _cameraController = CameraController(
        cameraDescriptions[0],
        ResolutionPreset.max,
      );

      _cameraController?.initialize().then((value) {
        if (!mounted) {
          return;
        }

        _cameraController?.setFocusMode(FocusMode.auto);
        _cameraController?.setFlashMode(FlashMode.off);
        _cameraController?.setZoomLevel(1.0);

        setState(() {});
      }).catchError((e) {
        if (e is CameraException) {
          Fluttertoast.showToast(msg: e.code);
        }
      });
    });
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

  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraPreview(_cameraController!),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 48),
                height: 56,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child: IconButton(
                  onPressed: _onTakePicture,
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(top: 48, right: 16),
                child: IconButton(
                  onPressed: _onToggleShowInfo,
                  icon: const Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isInfoShow,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
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
                      hasLocationPermission
                          ? StreamBuilder(
                              stream: Geolocator.getPositionStream(
                                locationSettings: locationSettings,
                              ),
                              builder: (ctx, snapshot) {
                                return Column(
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
                                      'Latitude: ${snapshot.data?.latitude}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Longitude: ${snapshot.data?.longitude}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                );
                              },
                            )
                          : ElevatedButton(
                              onPressed: _requestLocationPermission,
                              child: const Text('Enable Access Location'),
                            ),
                      const SizedBox(height: 16),
                      StreamBuilder(
                        stream: magnetometerEvents,
                        builder: (ctx, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Magnetometer',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'X: ${snapshot.data?.x}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Y: ${snapshot.data?.y}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Z: ${snapshot.data?.z}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dateTime,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return const Scaffold(
      body: Center(
        child: Text('Camera not available'),
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

  void _onToggleShowInfo() {
    setState(() {
      setState(() {
        isInfoShow = !isInfoShow;
      });
    });
  }

  void _onTakePicture() async {
    if (_cameraController?.value.isTakingPicture ?? false) {
      return;
    }

    lastPosition = await Geolocator.getCurrentPosition();
    lastMagnetometer = await magnetometerEvents.first;

    _cameraController?.takePicture().then((value) {
      Navigator.pushNamed(
        context,
        ImagePreviewPage.route,
        arguments: ImagePreviewArgs(
            filePath: value.path,
            createdAt: DateTime.now(),
            position: lastPosition,
            magnetometer: lastMagnetometer),
      );
    });
  }
}
