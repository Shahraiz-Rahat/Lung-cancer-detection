import 'package:Kaizen/view/Pictures/left_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RightImagePickerScreen extends StatefulWidget {
  @override
  _RightImagePickerScreen createState() => _RightImagePickerScreen();
}

class _RightImagePickerScreen extends State<RightImagePickerScreen> {
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
        title: Text('Right Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_pickedImage != null)
              Image.file(
                _pickedImage!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              Text('No image selected.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Right Side Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),
            if (_pickedImage != null)
              ElevatedButton(
                  child: Text('Pick Left Side Image'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeftImagePickerScreen()),
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
