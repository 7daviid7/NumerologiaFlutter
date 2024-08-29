import 'package:flutter/material.dart';
import 'dart:math';

class ArcWidget extends StatelessWidget {
  final Map<String, int> values;

  ArcWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: CustomPaint(
        painter: ArcPainter(values: values),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final Map<String, int> values;

  ArcPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width, size.height) / 2 - 20;
    
    // Dibuix de l'arc
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(arcRect, pi, pi, false, paint);

    // Dibuix de la fletxa
    final arrowEnd = Offset(center.dx, center.dy - 2 * radius);
    canvas.drawLine(center, arrowEnd, paint);

    // Dibuix de la punta de la fletxa
    final arrowTip1 = Offset(arrowEnd.dx - 10, arrowEnd.dy + 10);
    final arrowTip2 = Offset(arrowEnd.dx + 10, arrowEnd.dy + 10);
    canvas.drawLine(arrowEnd, arrowTip1, paint);
    canvas.drawLine(arrowEnd, arrowTip2, paint);

    // Dibuix del text
    _drawText(canvas, "Desarrollar", arrowEnd + Offset(0, -15));
    _drawText(canvas, "Apertura", center + Offset(0, 10));
    _drawText(canvas, "NL", center - Offset(0, radius + 20));
    _drawText(canvas, "Expresión", center + Offset(0, radius + 20));
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final textStyle = TextStyle(color: Colors.black, fontSize: 14);
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.maxFinite);
    textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
