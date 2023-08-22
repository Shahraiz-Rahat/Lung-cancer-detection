import 'package:Kaizen/view/home/home_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:google_ml_kit_example/vision_detector_views/painters/pose_painter.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'detector_view.dart';
// ignore: unused_import
import 'landmark_list.dart'; // Import the landmark_list.dart file
import 'painters/pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  String? _text;
  CustomPaint? _customPaint;
  DataTable? _customDataTable; // Define DataTable
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      detectionMode: DetectorViewMode.liveFeed,
      title: 'Pose Detector',
      customPaint: _customPaint,
      onImage: _processImage,
      text: _text,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
      child: _customDataTable,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _customDataTable = null; // Clear the DataTable
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
      // Your existing code for handling CustomPaint and PosePainter
    } else {
      // ignore: prefer_final_locals
      List<String> landmarkInfo = [];
      // ignore: prefer_final_locals
      List<double> xCoordinates = [];
      // ignore: prefer_final_locals
      List<double> yCoordinates = [];
      // ignore: prefer_final_locals
      List<double> zCoordinates = [];
      // ignore: prefer_final_locals
      List<double> likelihoods = [];
      _text = 'Poses found: ${poses.length}\n\n';
      _customPaint = null;

      for (final Pose pose in poses) {
        for (final type in pose.landmarks.keys) {
          final landmark = pose.landmarks[type]!;
          landmarkInfo.add(type.toString());
          xCoordinates.add(landmark.x);
          yCoordinates.add(landmark.y);
          zCoordinates.add(landmark.z);
          likelihoods.add(landmark.likelihood);
        }
      }

      setState(() {
        _customPaint = null;
      });

      // ignore: prefer_final_locals
      List<DataRow> rows = [];
      for (int i = 0; i < landmarkInfo.length; i++) {
        // ignore: prefer_final_locals
        DataRow row = DataRow(
          cells: [
            DataCell(Text('Landmark Type: ${landmarkInfo[i]}')),
            DataCell(Text(
                'x: ${xCoordinates[i]}, y: ${yCoordinates[i]}, z: ${zCoordinates[i]}')),
            DataCell(Text('Likelihood: ${likelihoods[i]}')),
          ],
        );
        rows.add(row);
      }

      // ignore: prefer_final_locals
      DataTable dataTable = DataTable(
        columns: [
          DataColumn(label: Text('Landmark')),
          DataColumn(label: Text('Coordinates')),
          DataColumn(label: Text('Likelihood')),
        ],
        rows: rows,
      );

      setState(() {
        _customDataTable = dataTable;
      });

      _navigateToPDFScreen(
        landmarkInfo,
        xCoordinates,
        yCoordinates,
        zCoordinates,
        likelihoods,
        inputImage,
      ); // Navigate to LandmarkListScreen
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _navigateToPDFScreen(
    List<String> landmarkInfo,
    List<double>? xCoordinates,
    List<double> yCoordinates,
    List<double> zCoordinates,
    List<double> likelihoods,
    InputImage inputImage,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(
          landmarkInfo: landmarkInfo,
          xCoordinates: xCoordinates,
          yCoordinates: yCoordinates,
          zCoordinates: zCoordinates,
          likelihoods: likelihoods,
          inputImage: inputImage, // Pass the image data
        ),
        //     LandmarkListScreen(
        //   landmarkInfo,
        //   xCoordinates!,
        //   yCoordinates,
        //   zCoordinates,
        //   likelihoods,
        // ),
      ),
    );
  }
}
