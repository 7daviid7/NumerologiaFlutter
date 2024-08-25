import 'package:flutter/material.dart';
import 'dart:math';


class DiagramPainter extends CustomPainter {
  final Map<String, int> results;

  DiagramPainter(this.results);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Define positions for circles
    Offset centerLifePath = Offset(size.width * 0.5, size.height * 0.2);
    Offset centerExpression = Offset(size.width * 0.2, size.height * 0.5);
    Offset centerMission = Offset(size.width * 0.8, size.height * 0.5);
    Offset centerInitiation = Offset(size.width * 0.5, size.height * 0.8);
    
    // Draw circles and text
    drawCircleWithText(canvas, paint, textPainter, centerLifePath, 'Camino de Vida', results['Camino de Vida'] ?? 0);
    drawCircleWithText(canvas, paint, textPainter, centerExpression, 'Expresión', results['Expresión'] ?? 0);
    drawCircleWithText(canvas, paint, textPainter, centerMission, 'Mision', results['Mision'] ?? 0);
    drawCircleWithText(canvas, paint, textPainter, centerInitiation, 'Iniciacio', results['Iniciacio'] ?? 0);
    
    // Draw arrows between circles
    drawArrow(canvas, paint, centerLifePath, centerMission);
    drawArrow(canvas, paint, centerExpression, centerMission);
    drawArrow(canvas, paint, centerMission, centerInitiation);
  }

  void drawCircleWithText(Canvas canvas, Paint paint, TextPainter textPainter, Offset center, String label, int value) {
    // Draw circle
    double radius = 40.0;
    canvas.drawCircle(center, radius, paint);

    // Draw label text
    textPainter.text = TextSpan(
      text: '$label\n$value',
      style: TextStyle(color: Colors.black, fontSize: 16),
    );
    textPainter.layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void drawArrow(Canvas canvas, Paint paint, Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.lineTo(end.dx, end.dy);
    
    canvas.drawPath(path, paint);

    // Calculate arrowhead
    double arrowHeadSize = 10;
    double angle = (end - start).direction;
    Offset arrowPoint1 = end - Offset(cos(angle - pi / 6) * arrowHeadSize, sin(angle - pi / 6) * arrowHeadSize);
    Offset arrowPoint2 = end - Offset(cos(angle + pi / 6) * arrowHeadSize, sin(angle + pi / 6) * arrowHeadSize);
    
    path.moveTo(end.dx, end.dy);
    path.lineTo(arrowPoint1.dx, arrowPoint1.dy);
    path.lineTo(arrowPoint2.dx, arrowPoint2.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ResultsDiagram extends StatelessWidget {
  final Map<String, int> results;

  ResultsDiagram({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultats')),
      body: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: DiagramPainter(results),
      ),
    );
  }
}
