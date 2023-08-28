import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

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
import 'package:screenshot/screenshot.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'line_draw.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../common_widget/line_painter.dart';
import '../../models/pose.dart';
import '../../models/pose_landmark.dart';
import '../../png_image.dart';
import '../../pose_mask_painter.dart';

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
  GlobalKey _globalKey = GlobalKey();
  ScreenshotController _screenshotController = ScreenshotController();

  Image? _selectedImage;
  CameraController? _cameraController;
  Future<void>? _cameraInitialization;
  bool isFrontCamera = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  GyroscopeEvent? gyroscopeEvent;
  Size _imageSize = Size.zero;
  Pose1? _detectedPose;
  ui.Image? _maskImage;

  Paint _linePaint = Paint()..color = Colors.red; // Customize the paint color
  List<Offset> _linePoints = []; // Store the points for drawing lines
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  List<double>? _accelerometerValues = [0.0, 0.0, 0.0];
  StateSetter? _setState;

  @override
  void initState() {
    super.initState();
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
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      double x = event.x, y = event.y, z = event.z;
      double norm_Of_g =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      x = event.x / norm_Of_g;
      y = event.y / norm_Of_g;
      z = event.z / norm_Of_g;

      double xInclination = -(asin(x) * (180 / pi));
      double yInclination = (acos(y) * (180 / pi));
      double zInclination = (atan(z) * (180 / pi));

      if (_setState != null) {
        _setState!(() {
          _accelerometerValues = [xInclination, yInclination, zInclination];
        });
      }
    }));
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _cameraController?.dispose();
    // _stopLineUpdateTimer(); // Stop the line update timer
    super.dispose();
  }

  Future<void> _pickVirtualImage() async {
    initializeCamera(isFrontCamera);
    await _cameraInitialization;

    if (_cameraController!.value.isInitialized) {
      XFile? capturedImage; // To store the captured image

      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
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
                    // CustomPaint(
                    //   painter: LinePainter(_linePoints, _linePaint),
                    //   size: Size.infinite,
                    // ),
                  ),
                  Positioned.fill(
                    child: Transform.rotate(
                      angle: _accelerometerValues![0] * 0.0174533,
                      child: Container(
                          color: Colors.transparent,
                          child: Divider(height: 300, color: Colors.white)),
                    ),
                  ),
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      isFrontCamera
                          ? (isFrontCamera = false)
                          : (isFrontCamera = true); // Toggle camera
                      print(isFrontCamera);
                      await _cameraController!.dispose();
                      await initializeCamera(isFrontCamera);
                      _pickVirtualImage();
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
            );
          }));
        },
      );

      if (capturedImage != null) {
        setState(() {
          _pickedImageXFile = capturedImage;
          _pickedImage = File(capturedImage!.path);
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source, String? type) async {
    ImagePicker? _imagePicker;
    _imagePicker = ImagePicker();
    final pickedImage = await _imagePicker.pickImage(source: source);
    print("😍");
    print(pickedImage?.path);
    setState(() {
      if (pickedImage != null) {
        _pickedImageXFile = pickedImage;
        _pickedImage = File(pickedImage.path);
        // print("👍");
        // print(_pickedImage?.lengthSync());

        _selectedImage = Image.file(File(pickedImage.path));
      }
    });
  }

  Map<String, dynamic> posesJson = {};
  List<PoseLandmark1> posesList = [];
  void _handlePose(dynamic? pose) {
    // Ignore if navigated out of the page.
    if (!mounted) return;

    setState(() {
      _detectedPose = pose;
    });
  }

  void _resetState() {
    setState(() {
      // _maskImage = null;
      _detectedPose = null;
      // _imageSize = Size.zero;
    });
  }

  Future<void> _analyzeImage(type) async {
    _resetState();
    List<Pose> poses = [];
    if (_selectedImage != null && _pickedImageXFile != null) {
      PngImage? pngImage = await _selectedImage?.toPngImage();
      if (pngImage == null) return;
      setState(() {
        _imageSize =
            Size(pngImage.width.toDouble(), pngImage.height.toDouble());
      });

      poses = await detectPoses(_pickedImageXFile);
      posesJson = convertPosesToJson(poses);
      posesList = posesJson['list'];

      final posesPaintList = await Pose1(landmarks: posesList);
      // print(jsonEncode(posesJson['json']));
      _handlePose(posesPaintList);
    }

    setState(() {
      if (poses.length > 0) {
        // _pickedImage = File(pickedImage.path);
        _posesFound = poses.length;
        _isAnalyzed = true;
      }
    });
  }

  void saveImage(type) async {
    // Capture the screenshot
    final capturedImage =
        await _screenshotController.capture(delay: Duration(microseconds: 10));

    // Save the captured image to device storage
    final result = await ImageGallerySaver.saveImage(
      capturedImage!,
      quality: 100,
      name: '${type}_image',
    );

    if (result['isSuccess']) {
      // Image saved successfully

      File _savedImage = File("/storage/emulated/0/Pictures/${type}_image.jpg");

      setState(() {
        Provider.of<UserData>(context, listen: false)
            .updateImageData(type, _savedImage, posesJson['json']);
        // print('Image saved to ${result['filePath']}');
      });
    } else {
      // Saving failed
      print('Image saving failed.');
    }
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
            if (_selectedImage != null)
              RepaintBoundary(
                  key: _globalKey,
                  child: Screenshot(
                    controller: _screenshotController,
                    child: GestureDetector(
                      child: ClipRect(
                        child: CustomPaint(
                          child: _selectedImage,
                          foregroundPainter: PoseMaskPainter(
                            pose: _detectedPose,
                            mask: _maskImage,
                            imageSize: _imageSize,
                          ),
                        ),
                      ),
                    ),
                  ))
            else
              Text('No image selected.'),
            SizedBox(height: 5),
            if (_selectedImage != null)
              Text("Poses Found ${_posesFound.toString()}"),
            SizedBox(height: 20),
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LineDraw()),
                  );
                },
                child: Text('Draw line'),
              ),
            ]),
            // ElevatedButton(
            //   onPressed: _pickImage,
            //   child: Text('Pick an Image'),
            // ),
            if (_selectedImage != null && widget.index <= 4)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: RoundButton(
                    title: 'Analyze Image',
                    onPressed: () {
                      _analyzeImage(type);
                    }),
              ),
            if (_detectedPose != null &&
                _selectedImage != null &&
                _isAnalyzed &&
                widget.index <= 3)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: RoundButton(
                    title: 'Next',
                    onPressed: () {
                      saveImage(type);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OnboardingImagePickerScreen(
                                index: widget.index + 1)),
                      );
                    }),
              ),
            if (_selectedImage != null && _isAnalyzed && widget.index >= 4)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: RoundButton(
                    title: 'View Report',
                    onPressed: () {
                      saveImage(type);
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
