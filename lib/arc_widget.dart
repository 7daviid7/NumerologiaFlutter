import 'package:flutter/material.dart';
import 'dart:math';

class ArcWidget extends StatelessWidget {
  final Map<String, int> values;

  ArcWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxWidth, // Mantenim un widget quadrat
          child: CustomPaint(
            painter: ArcPainter(values: values),
          ),
        );
      },
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

    // Defineix el centre de la fletxa
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 -60;

    // Dibuixa la fletxa
    final arrowStart = Offset(center.dx, center.dy + radius); // Inici de la fletxa
    final arrowEnd = Offset(center.dx, center.dy - radius); // Final de la fletxa
    canvas.drawLine(arrowStart, arrowEnd, paint);

    // Dibuixa la punta de la fletxa
    final arrowTip1 = Offset(arrowEnd.dx - 10, arrowEnd.dy + 10);
    final arrowTip2 = Offset(arrowEnd.dx + 10, arrowEnd.dy + 10);
    canvas.drawLine(arrowEnd, arrowTip1, paint);
    canvas.drawLine(arrowEnd, arrowTip2, paint);

    // Ajusta el centre de l'arc perquè el semicercle estigui centrat amb la fletxa
    final arcCenter = Offset(center.dx, center.dy + radius);
    final arcRadius = radius;

    // Dibuixa l'arc
    final Rect arcRect = Rect.fromCircle(center: arcCenter, radius: arcRadius);
    canvas.drawArc(arcRect, pi, pi, false, paint);

     // Mostrar els textos utilitzant el `Map`
    if (values.length >= 4) {
      // Primers i segons valors per als extrems del semicercle
      final arcLeft = Offset(arcCenter.dx - arcRadius, arcCenter.dy);
      final arcRight = Offset(arcCenter.dx + arcRadius, arcCenter.dy);
      _drawText(canvas, "${values.keys.elementAt(0)}", values.values.elementAt(0), arcLeft + Offset(-30, 20));
      _drawText(canvas, "${values.keys.elementAt(1)}", values.values.elementAt(1), arcRight + Offset(30, 20));

      // Tercer i quart valors per als extrems de la fletxa
      _drawText(canvas, "${values.keys.elementAt(2)}", values.values.elementAt(2), arrowEnd + Offset(0, -30));
      _drawText(canvas, "${values.keys.elementAt(3)}", values.values.elementAt(3), arrowStart + Offset(0, 10));
    }
  }

  void _drawText(Canvas canvas, String key, int value, Offset offset) {
    final TextStyle titleStyle = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal);
    final TextStyle valueStyle = TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold);

    final TextSpan titleSpan = TextSpan(text: key, style: titleStyle);
    final TextSpan valueSpan = TextSpan(text: '\n$value', style: valueStyle);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(children: [titleSpan, valueSpan]),
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