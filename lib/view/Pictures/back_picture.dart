import 'package:Kaizen/common_widget/round_button.dart';
// ignore: unused_import
import 'package:Kaizen/view/Pictures/details_form.dart';
import 'package:Kaizen/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BackImagePickerScreen extends StatefulWidget {
  @override
  _BackImagePickerScreen createState() => _BackImagePickerScreen();
}

class _BackImagePickerScreen extends State<BackImagePickerScreen> {
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
        title: Text('Back Picture'),
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
              child: Text('Pick Back Side Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Take a Picture'),
            ),
            if (_pickedImage != null)
              // ElevatedButton(
              //     child: Text('Enter Details'),
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (context) => DetailsForm()),
              //       );
              //     }
              //     ),
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
            if (_pickedImage != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: RoundButton(
                    title: 'Download Report',
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
