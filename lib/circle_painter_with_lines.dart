import 'package:flutter/material.dart';

class CirclePainterWithLines extends CustomPainter {
  final int value; // Valor a mostrar dins del cercle
  final String label; // Etiqueta per a mostrar
  final Offset? nextCirclePosition; // Posició del següent cercle per dibuixar la línia

  CirclePainterWithLines(this.value, this.label, {this.nextCirclePosition});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final Paint fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Dibuixar el cercle
    canvas.drawCircle(Offset(centerX, centerY), radius, fillPaint);
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Dibuixar el valor dins del cercle
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$value',
        style: TextStyle(color: Colors.black, fontSize: 24),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(centerX - textPainter.width / 2, centerY - textPainter.height / 2));

    // Dibuixar l'etiqueta sota del cercle
    final labelPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    labelPainter.paint(canvas, Offset(centerX - labelPainter.width / 2, centerY + radius / 2));

    // Dibuixar una línia cap al següent cercle, si es proporciona la posició
    if (nextCirclePosition != null) {
      final linePaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2.0;
      
      canvas.drawLine(Offset(centerX, centerY + radius), nextCirclePosition!, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
