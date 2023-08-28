import 'package:Kaizen/common_widget/line_painter.dart';
import 'package:flutter/material.dart';

class LineDraw extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.rotate(
          // angle: bacteria.rotation,
          angle: 0.25,
          // transform: Matrix4.rotationY(0.25),
          child: Container(
            color: Colors.white,
            width: 300,
            height: 300,
            // child: CustomPaint(
            //   foregroundPainter: //LinePainter(),
            // ),
          ),
        ),
      ),
    );
  }
}
