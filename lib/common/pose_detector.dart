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