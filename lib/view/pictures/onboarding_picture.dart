import 'dart:convert';

import 'package:Kaizen/common/color_extension.dart';
import 'package:Kaizen/common/pose_detector.dart';
import 'package:Kaizen/common_widget/round_button.dart';
import 'package:Kaizen/providers/onboarding_provider.dart';
import 'package:Kaizen/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';

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
            Text(
              'Pick Image From ${type.toUpperCase()} Side ',
              style: TextStyle(fontSize: 18, color: FitColors.primary),
            ),
            SizedBox(height: 20),
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                height: 400,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              Text('No image selected.'),
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
            ]),
            // ElevatedButton(
            //   onPressed: _pickImage,
            //   child: Text('Pick an Image'),
            // ),
            if (_pickedImage != null && widget.index <= 4)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: RoundButton(
                    title: 'Analyze Image',
                    onPressed: () {
                      _analyzeImage(type);
                    }),
              ),
            if (_pickedImage != null && _isAnalyzed && widget.index <= 3)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
        )
      ),
    );
  }
}
