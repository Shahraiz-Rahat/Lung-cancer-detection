import 'package:Kaizen/view/Pictures/front_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'view/login/on_boarding_view.dart';
import 'vision_detector_views/pose_detector_view.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Workout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false),
      home:
          // Home(),
          OnBoardingView(),
    );
  }
}

class Model extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Model Viewer')),
        body: const ModelViewer(
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          src: 'assets/Astronaut.glb',
          alt: 'A 3D model of an astronaut',
          ar: true,
          arModes: ['scene-viewer', 'webxr', 'quick-look'],
          autoRotate: true,
          iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
          disableZoom: true,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaizen Health Group'),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ExpansionTile(
                    backgroundColor: Colors.cyanAccent,
                    title: const Text('Get Started'),
                    children: [
                      CustomCard(
                        'Take Pictures',
                        FrontImagePickerScreen(),
                        // PictureScreen(
                        //   title: "Front Picture",
                        // )
                        //  PoseDetectorView()
                      ),
                    ],
                  ),
                  ExpansionTile(
                    backgroundColor: Colors.cyanAccent,
                    title: const Text('Select Body Part'),
                    children: [
                      CustomCard('View Anatomy', Model()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;
  final bool featureCompleted;

  const CustomCard(this._label, this._viewPage, {this.featureCompleted = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).primaryColor,
        title: Text(
          _label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _viewPage),
          );
        },
      ),
    );
  }
}

class PictureScreen extends StatefulWidget {
  final String title;

  PictureScreen({required this.title});

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  List<String> capturedImages = [];
  bool isImageCaptureInProgress = false;

  Future<void> _captureImage() async {
    if (isImageCaptureInProgress) {
      return;
    }

    isImageCaptureInProgress = true;

    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        capturedImages.add(pickedFile.path);
      });

      if (capturedImages.length == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(capturedImages),
          ),
        );
      } else {
        Navigator.of(context).pop(); // Close the current picture screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PictureScreen(
              title: getTitleForNextImage(capturedImages.length),
            ),
          ),
        );
      }
    }

    await Future.delayed(Duration(milliseconds: 500)); // Debounce duration
    isImageCaptureInProgress = false;
  }

  String getTitleForNextImage(int index) {
    if (index == 1) {
      return 'Right Picture';
    } else if (index == 2) {
      return 'Left Picture';
    } else if (index == 3) {
      return 'Back Picture';
    }
    return 'Unknown Picture';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _captureImage();
              },
              child: Text('Capture Picture'),
            ),
            SizedBox(height: 16),
            Text('Captured Images: ${capturedImages.join(", ")}'),
          ],
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final List<dynamic> capturedImages;

  DetailsScreen(this.capturedImages);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Widgets to input details (Name, DOB, Gender)

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmitScreen(capturedImages),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitScreen extends StatelessWidget {
  final List<dynamic> capturedImages;

  SubmitScreen(this.capturedImages);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Report'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Display captured images and details
            Text('Captured ${capturedImages.length} images'),

            ElevatedButton(
              onPressed: () {
                // Implement API call to submit data
                // Include images and pose data in the API call

                // After submission, you can navigate to a success screen or back to the details screen
              },
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
