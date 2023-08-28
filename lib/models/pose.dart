import 'pose_landmark.dart';
import 'pose_landmark_type.dart';

class Pose1 {
  final List<PoseLandmark1> landmarks;

  Pose1({required this.landmarks});

  factory Pose1.fromMap(Map<Object?, Object?> map) {
    final landmarkObjectList = map['landmarks'] as List;
    final landmarkList =
        landmarkObjectList.map((it) => PoseLandmark1.fromMap(it)).toList();
    return Pose1(landmarks: landmarkList);
  }

  static const List<List<PoseLandmarkType1>> connections = [
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
