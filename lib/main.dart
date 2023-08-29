import 'package:Kaizen/providers/onboarding_provider.dart';
// ignore: unused_import
import 'package:Kaizen/view/Pictures/onboarding_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
// ignore: unused_import
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// ignore: unused_import
import 'view/login/on_boarding_view.dart';
// ignore: unused_import
import 'vision_detector_views/pose_detector_view.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:image_picker/image_picker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MyApp(),
    ),
  );
  // runApp(const MyApp());
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
      //OnboardingImagePickerScreen(index: 1),
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
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Kaizen Health Care'),
          centerTitle: true,
          elevation: 5,
        ),
        body: Stack(children: [
          Image.asset(
            'assets/img/doc_on_main.jpg',
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Theme(
                        data: theme,
                        child: ExpansionTile(
                          // backgroundColor: Colors.cyanAccent,
                          title: const Text(
                            'Get Analysis',
                            style: TextStyle(color: Colors.white),
                          ),

                          children: [
                            CustomCard(
                              'Take Pictures',
                              OnboardingImagePickerScreen(index: 1),
                              // PictureScreen(
                              //   title: "Front Picture",
                              // )
                              //  PoseDetectorView()
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Color.fromARGB(255, 255, 255, 255),
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        height: 10,
                      ),
                      Theme(
                        data: theme,
                        child: ExpansionTile(
                          // backgroundColor: Colors.cyanAccent,
                          title: const Text(
                            'Select Body Type',
                            style: TextStyle(color: Colors.white),
                          ),
                          children: [
                            CustomCard('View Anatomy', Model()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]));
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



