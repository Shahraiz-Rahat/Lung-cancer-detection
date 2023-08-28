enum PoseLandmarkType1 {
  unknown,
  leftAnkle,
  leftEar,
  leftElbow,
  leftEye,
  leftEyeInner,
  leftEyeOuter,
  leftHeel,
  leftHip,
  leftIndexFinger,
  leftKnee,
  leftPinkyFinger,
  leftShoulder,
  leftThumb,
  leftToe,
  leftWrist,
  mouthLeft,
  mouthRight,
  nose,
  rightAnkle,
  rightEar,
  rightElbow,
  rightEye,
  rightEyeInner,
  rightEyeOuter,
  rightHeel,
  rightHip,
  rightIndexFinger,
  rightKnee,
  rightPinkyFinger,
  rightShoulder,
  rightThumb,
  rightToe,
  rightWrist,
}

extension PoseLandmarkTypeExtension on PoseLandmarkType1 {
  static PoseLandmarkType1 fromString(String key) {
    switch (key) {
      case "nose":
        return PoseLandmarkType1.nose;
      case "leftEyeInner":
        return PoseLandmarkType1.leftEyeInner;
      case "leftEye":
        return PoseLandmarkType1.leftEye;
      case "leftEyeOuter":
        return PoseLandmarkType1.leftEyeOuter;
      case "rightEyeInner":
        return PoseLandmarkType1.rightEyeInner;
      case "rightEye":
        return PoseLandmarkType1.rightEye;
      case "rightEyeOuter":
        return PoseLandmarkType1.rightEyeOuter;
      case "leftEar":
        return PoseLandmarkType1.leftEar;
      case "rightEar":
        return PoseLandmarkType1.rightEar;
      case "leftMouth":
        return PoseLandmarkType1.mouthLeft;
      case "rightMouth":
        return PoseLandmarkType1.mouthRight;
      case "leftShoulder":
        return PoseLandmarkType1.leftShoulder;
      case "rightShoulder":
        return PoseLandmarkType1.rightShoulder;
      case "leftElbow":
        return PoseLandmarkType1.leftElbow;
      case "rightElbow":
        return PoseLandmarkType1.rightElbow;
      case "leftWrist":
        return PoseLandmarkType1.leftWrist;
      case "rightWrist":
        return PoseLandmarkType1.rightWrist;
      case "leftPinky":
        return PoseLandmarkType1.leftPinkyFinger;
      case "rightPinky":
        return PoseLandmarkType1.rightPinkyFinger;
      case "leftIndex":
        return PoseLandmarkType1.leftIndexFinger;
      case "rightIndex":
        return PoseLandmarkType1.rightIndexFinger;
      case "rightThumb":
        return PoseLandmarkType1.rightThumb;
      case "leftThumb":
        return PoseLandmarkType1.leftThumb;
      case "leftHip":
        return PoseLandmarkType1.leftHip;
      case "rightHip":
        return PoseLandmarkType1.rightHip;
      case "leftKnee":
        return PoseLandmarkType1.leftKnee;
      case "rightKnee":
        return PoseLandmarkType1.rightKnee;
      case "leftAnkle":
        return PoseLandmarkType1.leftAnkle;
      case "rightAnkle":
        return PoseLandmarkType1.rightAnkle;
      case "leftHeel":
        return PoseLandmarkType1.leftHeel;
      case "rightHeel":
        return PoseLandmarkType1.rightHeel;
      case "leftFootIndex":
        return PoseLandmarkType1.leftToe;
      case "rightFootIndex":
        return PoseLandmarkType1.rightToe;
    }
    return PoseLandmarkType1.unknown;
  }

  static PoseLandmarkType1 fromId(int id) {
    switch (id) {
      case 0:
        return PoseLandmarkType1.nose;
      case 1:
        return PoseLandmarkType1.leftEyeInner;
      case 2:
        return PoseLandmarkType1.leftEye;
      case 3:
        return PoseLandmarkType1.leftEyeOuter;
      case 4:
        return PoseLandmarkType1.rightEyeInner;
      case 5:
        return PoseLandmarkType1.rightEye;
      case 6:
        return PoseLandmarkType1.rightEyeOuter;
      case 7:
        return PoseLandmarkType1.leftEar;
      case 8:
        return PoseLandmarkType1.rightEar;
      case 9:
        return PoseLandmarkType1.mouthLeft;
      case 10:
        return PoseLandmarkType1.mouthRight;
      case 11:
        return PoseLandmarkType1.leftShoulder;
      case 12:
        return PoseLandmarkType1.rightShoulder;
      case 13:
        return PoseLandmarkType1.leftElbow;
      case 14:
        return PoseLandmarkType1.rightElbow;
      case 15:
        return PoseLandmarkType1.leftWrist;
      case 16:
        return PoseLandmarkType1.rightWrist;
      case 17:
        return PoseLandmarkType1.leftPinkyFinger;
      case 18:
        return PoseLandmarkType1.rightPinkyFinger;
      case 19:
        return PoseLandmarkType1.leftIndexFinger;
      case 20:
        return PoseLandmarkType1.rightIndexFinger;
      case 21:
        return PoseLandmarkType1.leftThumb;
      case 22:
        return PoseLandmarkType1.rightThumb;
      case 23:
        return PoseLandmarkType1.leftHip;
      case 24:
        return PoseLandmarkType1.rightHip;
      case 25:
        return PoseLandmarkType1.leftKnee;
      case 26:
        return PoseLandmarkType1.rightKnee;
      case 27:
        return PoseLandmarkType1.leftAnkle;
      case 28:
        return PoseLandmarkType1.rightAnkle;
      case 29:
        return PoseLandmarkType1.leftHeel;
      case 30:
        return PoseLandmarkType1.rightHeel;
      case 31:
        return PoseLandmarkType1.leftToe;
      case 32:
        return PoseLandmarkType1.rightToe;
      default:
        return PoseLandmarkType1.unknown;
    }
  }

  bool get isLeftSide {
    switch (this) {
      case PoseLandmarkType1.leftAnkle:
      case PoseLandmarkType1.leftEar:
      case PoseLandmarkType1.leftElbow:
      case PoseLandmarkType1.leftEye:
      case PoseLandmarkType1.leftEyeInner:
      case PoseLandmarkType1.leftEyeOuter:
      case PoseLandmarkType1.leftHeel:
      case PoseLandmarkType1.leftHip:
      case PoseLandmarkType1.leftIndexFinger:
      case PoseLandmarkType1.leftKnee:
      case PoseLandmarkType1.leftPinkyFinger:
      case PoseLandmarkType1.leftShoulder:
      case PoseLandmarkType1.leftThumb:
      case PoseLandmarkType1.leftToe:
      case PoseLandmarkType1.leftWrist:
      case PoseLandmarkType1.mouthLeft:
        return true;
      default:
        return false;
    }
  }

  bool get isRightSide {
    switch (this) {
      case PoseLandmarkType1.rightAnkle:
      case PoseLandmarkType1.rightEar:
      case PoseLandmarkType1.rightElbow:
      case PoseLandmarkType1.rightEye:
      case PoseLandmarkType1.rightEyeInner:
      case PoseLandmarkType1.rightEyeOuter:
      case PoseLandmarkType1.rightHeel:
      case PoseLandmarkType1.rightHip:
      case PoseLandmarkType1.rightIndexFinger:
      case PoseLandmarkType1.rightKnee:
      case PoseLandmarkType1.rightPinkyFinger:
      case PoseLandmarkType1.rightShoulder:
      case PoseLandmarkType1.rightThumb:
      case PoseLandmarkType1.rightToe:
      case PoseLandmarkType1.rightWrist:
      case PoseLandmarkType1.mouthRight:
        return true;
      default:
        return false;
    }
  }
}
