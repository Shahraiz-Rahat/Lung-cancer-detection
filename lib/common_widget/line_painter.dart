import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class LinePainter extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;

  LinePainter(this.startPoint, this.endPoint);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


// class LinePainter extends CustomPainter {
//   //  final List<Offset> points;
//   //  final Paint linePaint;
//   // //
//   //  LinePainter(this.points, this.linePaint);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
//     final paint = Paint()
//       ..strokeWidth = 4
//     ..strokeCap = StrokeCap.round
//     ..color = Colors.white;
//     canvas.drawLine(
//         Offset(size.width * 3/8 , size.height * 1/2),
//         Offset(size.width * 5/8 , size.height * 1/2),
//     paint,
//     );
//
//
//     // for (int i = 0; i < points.length - 1; i++) {
//     //   canvas.drawLine(points[i], points[i + 1], paint);
//     //   print(points[i]);
//     // }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
