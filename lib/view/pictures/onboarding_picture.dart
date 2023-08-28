import 'dart:async';
import 'dart:convert';

import 'package:Kaizen/common/color_extension.dart';
import 'package:Kaizen/common/pose_detector.dart';
import 'package:Kaizen/common_widget/round_button.dart';
import 'package:Kaizen/providers/onboarding_provider.dart';
import 'package:Kaizen/view/home/home_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../common_widget/line_painter.dart';

class OnboardingImagePickerScreen extends StatefulWidget {
  @override
  _OnboardingImagePickerScreen createState() => _OnboardingImagePickerScreen();
  final int index;
  OnboardingImagePickerScreen({Key? key, required this.index})
      : super(key: key);
}

class _OnboardingImagePickerScreen extends State<OnboardingImagePickerScreen> {
  XFile? _pickedImageXFile;
  File? _pickedImage;
  int? _posesFound = 0;
  bool _isAnalyzed = false;
  CameraController? _cameraController;
  Future<void>? _cameraInitialization;
  bool isFrontCamera = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  GyroscopeEvent? gyroscopeEvent;

  Paint _linePaint = Paint()..color = Colors.red; // Customize the paint color
  List<Offset> _linePoints = []; // Store the points for drawing lines

  @override
  void initState() {
    super.initState();
    initializeCamera(isFrontCamera);

    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      setState(() {
        gyroscopeEvent = event;
        // Update _linePoints based on gyroscope data
        if (gyroscopeEvent != null) {
          double rotationAngle =
              gyroscopeEvent!.x; // Use the angular velocity around the y-axis
          double screenWidth = MediaQuery.of(context).size.width;

          // Calculate new line points based on rotationAngle
          // Here, we'll move the lines horizontally based on the rotationAngle
          double deltaX = rotationAngle * 10; // Adjust the factor as needed
          for (int i = 0; i < _linePoints.length; i++) {
            _linePoints[i] =
                Offset(_linePoints[i].dx + deltaX, _linePoints[i].dy);
          }
        }
      });
    });
  }

  Future<void> initializeCamera(bool useFrontCamera) async {
    final cameras = await availableCameras();
    final cameraToUse = useFrontCamera ? cameras.last : cameras.first;

    _cameraController = CameraController(
      cameraToUse,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _cameraInitialization = _cameraController!.initialize();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _pickVirtualImage() async {
    await _cameraInitialization;

    if (_cameraController!.value.isInitialized) {
      XFile? capturedImage; // To store the captured image

      await showDialog(
        context: context,
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: FractionalOffset.center,
            children: <Widget>[
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                ),
              ),
              // Positioned.fill(
              //   child: Opacity(
              //     opacity: 0.3,
              //     child: gyroscopeEvent != null
              //         ? Transform.rotate(
              //             angle: gyroscopeEvent!.x,
              //             child: Image.asset(
              //               'assets/virtual_image.jpg',
              //               fit: BoxFit.fill,
              //             ),
              //           )
              //         : Image.asset(
              //             'assets/virtual_image.jpg',
              //             fit: BoxFit.fill,
              //           ),
              //   ),
              // ),
              Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset("assets/red_virtual_man_frame.png",
                  fit : BoxFit.contain
                  ),
                ),
                // CustomPaint(
                //   painter: LinePainter(_linePoints, _linePaint),
                //   size: Size.infinite,
                // ),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () async {
                   isFrontCamera ? (isFrontCamera = false) : (isFrontCamera = true) ; // Toggle camera
                   print(isFrontCamera);
                  await _cameraController!.dispose();
                  await initializeCamera(isFrontCamera);
                  setState(() {
                    _pickVirtualImage();
                  });
                },
                child: Icon(Icons.switch_camera),
              ),
              SizedBox(height: 16),
              FloatingActionButton(
                onPressed: () async {
                  capturedImage = await _cameraController!
                      .takePicture(); // Capture the picture
                  Navigator.pop(context);
                },
                child: Icon(Icons.camera),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          extendBodyBehindAppBar: true,
        ),
      );

      if (capturedImage != null) {
        setState(() {
          _pickedImageXFile = capturedImage;
          _pickedImage = File(capturedImage!.path);
        });
      }
      // if (capturedImage != null) {
      //   _cameraController?.dispose();
      //   initializeCamera(!isFrontCamera);
      // }
      // _cameraController?.dispose();
      // initializeCamera(isFrontCamera);
    }
  }

  Future<void> _pickImage(ImageSource source, String? type) async {
    ImagePicker? _imagePicker;
    _imagePicker = ImagePicker();
    final pickedImage = await _imagePicker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _pickedImageXFile = pickedImage;
        _pickedImage = File(pickedImage.path);
      }
    });
  }

  Map<String, dynamic> posesJson = {};
  Future<void> _analyzeImage(type) async {
    List<Pose> poses = [];
    if (_pickedImageXFile != null) {
      poses = await detectPoses(_pickedImageXFile);
      posesJson = convertPosesToJson(poses);
      print(jsonEncode(posesJson));

      //Put your code here
    }

    setState(() {
      if (poses.length > 0) {
        _posesFound = poses.length;
        Provider.of<UserData>(context, listen: false)
            .updateImageData(type, _pickedImage, posesJson);
        _isAnalyzed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? type = "front";
    if (widget.index == 1) {
      type = "front";
    } else if (widget.index == 2) {
      type = "right";
    } else if (widget.index == 3) {
      type = "left";
    } else if (widget.index == 4) {
      type = "back";
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 165, 204, 240),
      appBar: AppBar(
        title: Text('${type.toUpperCase()}  Picture'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 5),
            Text(
              'Pick Image From ${type.toUpperCase()} Side ',
              style: TextStyle(fontSize: 18, color: FitColors.primary),
            ),
            SizedBox(height: 10),
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                height: 400,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              Text('No image selected.'),
            SizedBox(height: 5),
            if (_pickedImage != null)
              Text("Poses Found ${_posesFound.toString()}"),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery, type),
                child: Text('Pick an Image'),
              ),
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.camera, type),
                child: Text('Take a Picture'),
              ),
              ElevatedButton(
                onPressed: () => _pickVirtualImage(),
                child: Text('virtual'),
              ),
            ]),
            // ElevatedButton(
            //   onPressed: _pickImage,
            //   child: Text('Pick an Image'),
            // ),
            if (_pickedImage != null && widget.index <= 4)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: RoundButton(
                    title: 'Analyze Image',
                    onPressed: () {
                      _analyzeImage(type);
                    }),
              ),
            if (_pickedImage != null && _isAnalyzed && widget.index <= 3)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: RoundButton(
                    title: 'Next',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingImagePickerScreen(
                                index: widget.index + 1)),
                      );
                    }),
              ),
            if (_pickedImage != null && _isAnalyzed && widget.index >= 4)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: RoundButton(
                    title: 'View Report',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PDFScreen()),
                      );
                    }),
              ),
          ],
        ),
      )),
    );
  }
}
