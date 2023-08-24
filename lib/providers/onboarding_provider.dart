import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class UserData extends ChangeNotifier {
  bool isAppleHealth = true;
  DateTime selectDate = DateTime.now();
  String selectHeight = '175 cm';
  String selectWeight = '66-70 kg';
  bool isMale = true;
  String name = 'John Doe';

  Map<String, dynamic>? imageData = {};

  void updateData({
    bool? isAppleHealth,
    DateTime? selectDate,
    String? selectHeight,
    String? selectWeight,
    bool? isMale,
    String? name,
  }) {
    if (isAppleHealth != null) this.isAppleHealth = isAppleHealth;
    if (selectDate != null) this.selectDate = selectDate;
    if (selectHeight != null) this.selectHeight = selectHeight;
    if (selectWeight != null) this.selectWeight = selectWeight;
    if (isMale != null) this.isMale = isMale;
    if (name != null) this.name = name;
    notifyListeners();
  }

  void updateImageData(String? type, File? image, Map<String, dynamic> posesJson) {
    imageData![type.toString()] = {"image": image, "posesJson": posesJson};
    notifyListeners();
  }
}
