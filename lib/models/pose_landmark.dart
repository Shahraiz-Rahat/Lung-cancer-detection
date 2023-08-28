import 'point3d.dart';
import 'pose_landmark_type.dart';

class PoseLandmark1 {
  final double inFrameLikelihood;
  final Point3d position;
  final PoseLandmarkType1 type;

  PoseLandmark1({
    required this.inFrameLikelihood,
    required this.position,
    required this.type,
  });

  factory PoseLandmark1.fromMap(Map<Object?, Object?> map) {
    return PoseLandmark1(
      inFrameLikelihood: map['inFrameLikelihood'] as double,
      position: Point3d.fromMap(map['position'] as Map<Object?, Object?>),
      type: PoseLandmarkTypeExtension.fromId(map['type'] as int),
    );
  }
}
