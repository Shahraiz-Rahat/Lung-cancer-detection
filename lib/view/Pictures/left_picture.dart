import 'package:Kaizen/view/Pictures/back_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LeftImagePickerScreen extends StatefulWidget {
  @override
  _LeftImagePickerScreen createState() => _LeftImagePickerScreen();
}

class _LeftImagePickerScreen extends State<LeftImagePickerScreen> {
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
        title: Text('Left Picture'),
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
              child: Text('Pick Left Side Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),
            if (_pickedImage != null)
              ElevatedButton(
                  child: Text('Pick Back Side Image'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BackImagePickerScreen()),
                    );
                  }),
          ],
        ),
      ),
    );
  }
}
