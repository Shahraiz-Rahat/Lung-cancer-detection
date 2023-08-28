import 'dart:ui' as ui;

// import 'package:Kaizen/models/pose_landmark_type.dart';
import 'package:flutter/widgets.dart';

import 'models/pose.dart';
import 'models/pose_landmark.dart';
import 'models/pose_landmark_type.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
// import 'package:body_detection/models/pose.dart';
// import 'package:body_detection/models/pose_landmark.dart';
// import 'package:body_detection/models/pose_landmark_type.dart';






class PoseMaskPainter extends CustomPainter {
  PoseMaskPainter({
    required this.pose,
    required this.mask,
    required this.imageSize,
  });

  final Pose1? pose;
  final ui.Image? mask;
  final Size imageSize;
  final pointPaint = Paint()..color = const Color.fromRGBO(255, 255, 255, 0.8);
  final leftPointPaint = Paint()..color = const Color.fromRGBO(223, 157, 80, 1);
  final rightPointPaint = Paint()
    ..color = const Color.fromRGBO(100, 208, 218, 1);
  final linePaint = Paint()
    ..color = const Color.fromRGBO(255, 255, 255, 0.9)
    ..strokeWidth = 3;
  final maskPaint = Paint()
    ..colorFilter = const ColorFilter.mode(
        Color.fromRGBO(0, 0, 255, 0.5), BlendMode.srcOut);


  @override
  void paint(Canvas canvas, Size size) {
    _paintMask(canvas, size);
    _paintPose(canvas, size);
  }

  void _paintPose(Canvas canvas, Size size) {
    if (pose == null) return;

    final double hRatio =
        imageSize.width == 0 ? 1 : size.width / imageSize.width;
    final double vRatio =
        imageSize.height == 0 ? 1 : size.height / imageSize.height;

    offsetForPart(PoseLandmark1 part) =>
        Offset(part.position.x * hRatio, part.position.y * vRatio);

    // Landmark connections
    final landmarksByType = {for (final it in pose!.landmarks) it.type: it};

    for (final connection in connections) {

      final point1 = offsetForPart(landmarksByType[connection[0]]!);
      final point2 = offsetForPart(landmarksByType[connection[1]]!);
      canvas.drawLine(point1, point2, linePaint);
    }
    for (final part in pose!.landmarks) {

      // Landmark points
      canvas.drawCircle(offsetForPart(part), 5, pointPaint);

      if (part.type.isLeftSide) {

        canvas.drawCircle(offsetForPart(part), 3, leftPointPaint);
      } else if (part.type.isRightSide) {
        canvas.drawCircle(offsetForPart(part), 3, rightPointPaint);
      }

      // Landmark labels
      TextSpan span = TextSpan(
        text: part.type.toString().substring(16),
        style: const TextStyle(
          color: Color.fromRGBO(0, 128, 255, 1),
          fontSize: 10,
          shadows: [
            ui.Shadow(
              color: Color.fromRGBO(255, 255, 255, 1),
              offset: Offset(1, 1),
              blurRadius: 1,
            ),
          ],
        ),
      );
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left);
      tp.textDirection = TextDirection.ltr;
      tp.layout();
      tp.paint(canvas, offsetForPart(part));
    }
  }

  void _paintMask(Canvas canvas, Size size) {

    if (mask == null) return;

    canvas.drawImageRect(
        mask!,
        Rect.fromLTWH(0, 0, mask!.width.toDouble(), mask!.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        maskPaint);
  }

  @override
  bool shouldRepaint(PoseMaskPainter oldDelegate) {

    return oldDelegate.pose != pose ||
        oldDelegate.mask != mask ||
        oldDelegate.imageSize != imageSize;
  }

  List<List<PoseLandmarkType1>> get connections => [
        [PoseLandmarkType1.leftEar, PoseLandmarkType1.leftEyeOuter],
        [PoseLandmarkType1.leftEyeOuter, PoseLandmarkType1.leftEye],
        [PoseLandmarkType1.leftEye, PoseLandmarkType1.leftEyeInner],
        [PoseLandmarkType1.leftEyeInner, PoseLandmarkType1.nose],
        [PoseLandmarkType1.nose, PoseLandmarkType1.rightEyeInner],
        [PoseLandmarkType1.rightEyeInner, PoseLandmarkType1.rightEye],
        [PoseLandmarkType1.rightEye, PoseLandmarkType1.rightEyeOuter],
        [PoseLandmarkType1.rightEyeOuter, PoseLandmarkType1.rightEar],
        [PoseLandmarkType1.mouthLeft, PoseLandmarkType1.mouthRight],
        [PoseLandmarkType1.leftShoulder, PoseLandmarkType1.rightShoulder],
        [PoseLandmarkType1.leftShoulder, PoseLandmarkType1.leftHip],
        [PoseLandmarkType1.rightShoulder, PoseLandmarkType1.rightHip],
        [PoseLandmarkType1.rightShoulder, PoseLandmarkType1.rightElbow],
        [PoseLandmarkType1.rightWrist, PoseLandmarkType1.rightElbow],
        [PoseLandmarkType1.rightWrist, PoseLandmarkType1.rightThumb],
        [PoseLandmarkType1.rightWrist, PoseLandmarkType1.rightIndexFinger],
        [PoseLandmarkType1.rightWrist, PoseLandmarkType1.rightPinkyFinger],
        [PoseLandmarkType1.leftHip, PoseLandmarkType1.rightHip],
        [PoseLandmarkType1.leftHip, PoseLandmarkType1.leftKnee],
        [PoseLandmarkType1.rightHip, PoseLandmarkType1.rightKnee],
        [PoseLandmarkType1.rightKnee, PoseLandmarkType1.rightAnkle],
        [PoseLandmarkType1.leftKnee, PoseLandmarkType1.leftAnkle],
        [PoseLandmarkType1.leftElbow, PoseLandmarkType1.leftShoulder],
        [PoseLandmarkType1.leftWrist, PoseLandmarkType1.leftElbow],
        [PoseLandmarkType1.leftWrist, PoseLandmarkType1.leftThumb],
        [PoseLandmarkType1.leftWrist, PoseLandmarkType1.leftIndexFinger],
        [PoseLandmarkType1.leftWrist, PoseLandmarkType1.leftPinkyFinger],
        [PoseLandmarkType1.leftAnkle, PoseLandmarkType1.leftHeel],
        [PoseLandmarkType1.leftAnkle, PoseLandmarkType1.leftToe],
        [PoseLandmarkType1.rightAnkle, PoseLandmarkType1.rightHeel],
        [PoseLandmarkType1.rightAnkle, PoseLandmarkType1.rightToe],
        [PoseLandmarkType1.rightHeel, PoseLandmarkType1.rightToe],
        [PoseLandmarkType1.leftHeel, PoseLandmarkType1.leftToe],
        [PoseLandmarkType1.rightIndexFinger, PoseLandmarkType1.rightPinkyFinger],
        [PoseLandmarkType1.leftIndexFinger, PoseLandmarkType1.leftPinkyFinger],
      ];
}
