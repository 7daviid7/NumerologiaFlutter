import 'package:flutter/material.dart';
import 'dart:math';
import 'numerology_calculation.dart';

class ArcWidget extends StatelessWidget {
  final Map<String, int> values;

  ArcWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth, // Mantenim un widget quadrat
          child: CustomPaint(
            painter: ArcPainter(values: values, maxWidth: constraints.maxWidth, maxHeight: constraints.maxHeight),
          ),
        );
      },
    );
  }
}

class ArcPainter extends CustomPainter {
  final Map<String, int> values;
  final double maxWidth;
  final double maxHeight;

  ArcPainter({required this.values, required this.maxWidth, required this.maxHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Defineix el centre de la fletxa
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 60;

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

    // Ajustar el mides del text en funció del contenidor
    final double textSize = min(maxWidth, maxHeight) / 17; // Ajusta el divisor per controlar la mida del text

    // Crear TextStyle amb mida ajustada
    final TextStyle titleStyle = TextStyle(color: Colors.black, fontSize: textSize, fontWeight: FontWeight.normal);
    final TextStyle valueStyle = TextStyle(color: Colors.black, fontSize: textSize, fontWeight: FontWeight.bold);

    // Mostrar els textos utilitzant el `Map`
    if (values.length >= 4) {
      // Primers i segons valors per als extrems del semicercle
      final arcLeft = Offset(arcCenter.dx - arcRadius, arcCenter.dy);
      final arcRight = Offset(arcCenter.dx + arcRadius, arcCenter.dy);
      _drawText(canvas, values.keys.elementAt(0), values.values.elementAt(0), arcLeft + Offset(0, 20), titleStyle, valueStyle);
      _drawText(canvas, values.keys.elementAt(1), values.values.elementAt(1), arcRight + Offset(10, 20), titleStyle, valueStyle);

      // Tercer i quart valors per als extrems de la fletxa
      _drawText(canvas, values.keys.elementAt(2), values.values.elementAt(2), arrowEnd + Offset(0, -30), titleStyle, valueStyle);
      _drawText(canvas, values.keys.elementAt(3), values.values.elementAt(3), arrowStart + Offset(0, 20), titleStyle, valueStyle);
    }
  }

  void _drawText(Canvas canvas, String key, int value, Offset offset, TextStyle titleStyle, TextStyle valueStyle) {
    final reducedValue = reduceToSingleDigit(value);
    final bool masterNumber = isMasterNumber(reducedValue);

    final TextSpan titleSpan = TextSpan(text: key, style: titleStyle);
    final TextSpan valueSpan = TextSpan(
      text: masterNumber ? '\n$reducedValue/${reduceToSingleDigitResult(reducedValue)}' : '\n$reducedValue',
      style: masterNumber
          ? valueStyle.copyWith(color: Colors.red, backgroundColor: Colors.yellow) // Resaltar números mestres
          : valueStyle,
    );

    // Crear TextPainter per al títol
    final TextPainter titlePainter = TextPainter(
      text: titleSpan,
      textDirection: TextDirection.ltr,
    );
    titlePainter.layout();

    // Crear TextPainter per al valor
    final TextPainter valuePainter = TextPainter(
      text: valueSpan,
      textDirection: TextDirection.ltr,
    );
    valuePainter.layout();

    // Calcular l'offset per centrar el text
    final double xOffset = offset.dx - max(titlePainter.width, valuePainter.width) / 2;
    final double yOffset = offset.dy;

    // Dibuixar el text títol
    titlePainter.paint(canvas, Offset(xOffset, yOffset - (titlePainter.height / 2) - (valuePainter.height / 2) + 10));

    // Dibuixar el text del valor centrat amb el text títol
    valuePainter.paint(canvas, Offset(xOffset+7, yOffset + (titlePainter.height / 2) - 25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
