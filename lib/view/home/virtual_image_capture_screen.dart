import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:camera/camera.dart';

class VirtualImageCaptureScreen extends StatefulWidget {
  @override
  _VirtualImageCaptureScreenState createState() =>
      _VirtualImageCaptureScreenState();
}

class _VirtualImageCaptureScreenState
    extends State<VirtualImageCaptureScreen> {
  CameraController? _cameraController;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool isFrontCamera = false;

  List<double>? _accelerometerValues = [0.0, 0.0, 0.0];
  StateSetter? _setState;

  @override
  void initState() {
    super.initState();
    _initializeCamera(isFrontCamera);
    initializeSensors();
  }

  Future<void> initializeSensors() async {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
          double x = event.x, y = event.y, z = event.z;
          double norm_Of_g =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          x = event.x / norm_Of_g;
          y = event.y / norm_Of_g;
          z = event.z / norm_Of_g;

          double xInclination = -(asin(x) * (180 / pi));
          double yInclination = (acos(y) * (180 / pi));
          double zInclination = (atan(z) * (180 / pi));

          setState(() {
            _accelerometerValues = [xInclination, yInclination, zInclination];
            print(_accelerometerValues![0]);
          });

        });
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeCamera(bool useFrontCamera) async {
    final cameras = await availableCameras();
    final cameraToUse = useFrontCamera ? cameras.last : cameras.first;

    _cameraController = CameraController(
      cameraToUse,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Positioned.fill(
             child: AspectRatio(
                aspectRatio: _cameraController!.value.aspectRatio,
                child: CameraPreview(_cameraController!),
              ),
            ),

          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset("assets/red_virtual_man_frame.png",
                  fit: BoxFit.contain),
            ),
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: //0.25 ,
              _accelerometerValues![0] * 0.0174533,
              child: Container(
                  color: Colors.transparent,
                  child: Divider(height: 300,thickness:3 , color: Colors.white)),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'camera_switch',
            onPressed: () {
              setState(() {
                isFrontCamera = !isFrontCamera;
              });
              _cameraController?.dispose();
              _initializeCamera(isFrontCamera);
            },
            child: Icon(Icons.switch_camera),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'take_picture',
            onPressed: () async {
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized) {
                final capturedImage =
                await _cameraController!.takePicture();
                Navigator.pop(context, capturedImage);
              }
            },
            child: Icon(Icons.camera),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
