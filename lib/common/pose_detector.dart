import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

Future<List<Pose>> detectPoses(XFile? pickedFile) async {
  final path = pickedFile?.path;
  if (path == null) {
    return [];
  }
  final inputImage = InputImage.fromFilePath(path);
  final PoseDetector _poseDetector =
    PoseDetector(options: PoseDetectorOptions());
    final poses = await _poseDetector.processImage(inputImage);
    return poses;
}

Map<String, dynamic> convertPosesToJson(List<Pose> poses) {
  Map<String, dynamic> posesJson = {};
  for (final Pose pose in poses) {
    for (final type in pose.landmarks.keys) {
      final landmark = pose.landmarks[type]!;
      posesJson[type.toString()] = {
        "x": landmark.x.toStringAsFixed(2),
        "y": landmark.y.toStringAsFixed(2),
        "z": landmark.z.toStringAsFixed(2),
        "likelihood": landmark.likelihood.toStringAsFixed(2)
      };
    }
  }

  return posesJson;
}