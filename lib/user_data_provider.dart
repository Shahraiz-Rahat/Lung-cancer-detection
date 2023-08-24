import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

class UserData extends ChangeNotifier {
  bool isAppleHealth = true;
  DateTime selectDate = DateTime.now();
  String selectHeight = '175 cm';
  String selectWeight = '66-70 kg';
  bool isMale = true;
  String name = 'John Doe';

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
}
