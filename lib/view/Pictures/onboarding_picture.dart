import 'package:Kaizen/common/color_extension.dart';
import 'package:Kaizen/common/pose_detector.dart';
import 'package:Kaizen/common_widget/round_button.dart';
import 'package:Kaizen/providers/onboarding_provider.dart';
import 'package:Kaizen/view/Pictures/right_picture.dart';
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
  File? _pickedImage;
  int? _posesFound = 0;

  Future<void> _pickImage(ImageSource source, String? type) async {
    ImagePicker? _imagePicker;
    _imagePicker = ImagePicker();
    List<Pose> poses = [];
    print(type);
    final pickedImage = await _imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      poses = await detectPoses(pickedImage);
    }

    setState(() {
      if (pickedImage != null) {
        _pickedImage = File(pickedImage.path);
        _posesFound = poses.length;
        poses.forEach((element) {
          print(element);
        });
        // ignore: unused_local_variable
        // Update the picked image in the UserData class
        Provider.of<UserData>(context, listen: false)
            .updateImageData(type, _pickedImage, poses);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? type = "Front";
    print(widget.index);
    if (widget.index == 1) {
      type = "Front";
    } else if (widget.index == 2) {
      type = "Right";
    } else if (widget.index == 3) {
      type = "Left";
    } else if (widget.index == 4) {
      type = "Back";
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 165, 204, 240),
      appBar: AppBar(
        title: Text('${type}  Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pick Image From ${type} Side ',
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
            if (_pickedImage != null && widget.index <= 3)
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
            // ElevatedButton(
            //   style: ButtonStyle(),
            //     child: Text('Next'),
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => OnboardingImagePickerScreen(
            //                 index: widget.index + 1)),
            //       );
            //     }),
            if (_pickedImage != null && widget.index >= 4)
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
      ),
    );
  }
}
