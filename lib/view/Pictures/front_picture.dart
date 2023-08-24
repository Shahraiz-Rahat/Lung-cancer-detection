import 'package:Kaizen/view/Pictures/right_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FrontImagePickerScreen extends StatefulWidget {
  @override
  _FrontImagePickerScreen createState() => _FrontImagePickerScreen();
}

class _FrontImagePickerScreen extends State<FrontImagePickerScreen> {
  File? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _pickedImage = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Front Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                height: 400,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick an Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),
            // ElevatedButton(
            //   onPressed: _pickImage,
            //   child: Text('Pick an Image'),
            // ),
            if (_pickedImage != null)
              ElevatedButton(
                  child: Text('Pick Right Side Image'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RightImagePickerScreen()),
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
