import 'dart:math';
import 'package:flutter/cupertino.dart';

class CurvedText extends StatelessWidget {
  final List<double> angles;
  final String text;
  final TextStyle textStyle;

  CurvedText({
    required this.angles,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvedTextPainter(
        angles: angles,
        text: text,
        textStyle: textStyle,
      ),
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final List<double> angles;
  final String text;
  final TextStyle textStyle;

  CurvedTextPainter({
    required this.angles,
    required this.text,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    if (angles.length != text.length) {
      throw ArgumentError(
          "Number of angles must match the length of the text.");
    }

    for (int i = 0; i < text.length; i++) {
      final charAngle = angles[i];
      final x = centerX + radius * cos(charAngle) - textPainter.width / 2;
      final y = centerY + radius * sin(charAngle) - textPainter.height / 2;

      final offset = Offset(x, y);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
