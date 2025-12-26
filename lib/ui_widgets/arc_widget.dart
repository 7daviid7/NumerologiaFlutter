import 'package:flutter/material.dart';
import 'dart:math';
import '../services/numerology_calculation_service.dart';

class ArcWidget extends StatelessWidget {
  final Map<String, int> values;

  ArcWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    // Detectar si és mòbil (amplada de pantalla < 600)
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return LayoutBuilder(
      builder: (context, constraints) {
        double size = constraints.maxWidth;
        if (constraints.maxHeight != double.infinity) {
          size = min(constraints.maxWidth, constraints.maxHeight);
        }
        return Container(
          width: constraints.maxWidth, // Ocupa l'ample disponible per centrar
          alignment: Alignment.center,
          child: SizedBox(
            width: size,
            height: size, // Mantenim un widget quadrat
            child: CustomPaint(
              painter: ArcPainter(
                  values: values,
                  maxWidth: size,
                  maxHeight: size,
                  isMobile: isMobile),
            ),
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
  final bool isMobile;

  ArcPainter(
      {required this.values,
      required this.maxWidth,
      required this.maxHeight,
      required this.isMobile});

  @override
  void paint(Canvas canvas, Size size) {
    final double side = min(size.width, size.height);
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = side * 0.01 // Proportional stroke
      ..style = PaintingStyle.stroke;

    // Defineix el centre de la fletxa
    final center = Offset(size.width / 2, size.height / 2);
    // Reduim padding a % per fer-ho responsive
    final double padding = side * 0.15; // 15% padding
    final radius = side / 2 - padding;

    // Dibuixa la fletxa (Horitzontal: Esquerra -> Dreta)
    final arrowStart =
        Offset(center.dx - radius, center.dy); // Inici de la fletxa (Esquerra)
    final arrowEnd =
        Offset(center.dx + radius, center.dy); // Final de la fletxa (Dreta)
    canvas.drawLine(arrowStart, arrowEnd, paint);

    // Dibuixa la punta de la fletxa (a la Dreta)
    final double arrowTipSize = side * 0.025; // Proportional arrow tip
    final arrowTip1 =
        Offset(arrowEnd.dx - arrowTipSize, arrowEnd.dy - arrowTipSize);
    final arrowTip2 =
        Offset(arrowEnd.dx - arrowTipSize, arrowEnd.dy + arrowTipSize);
    canvas.drawLine(arrowEnd, arrowTip1, paint);
    canvas.drawLine(arrowEnd, arrowTip2, paint);

    // Ajusta el centre de l'arc (Coincideix amb l'inici de la fletxa a l'esquerra)
    final arcCenter = arrowStart;
    final arcRadius = radius;

    // Dibuixa l'arc (Semicercle cap a la dreta)
    // Start -PI/2 (Dalt) -> Sweep PI (Baix) -> Resultat: Corba a la dreta
    final Rect arcRect = Rect.fromCircle(center: arcCenter, radius: arcRadius);
    canvas.drawArc(arcRect, -pi / 2, pi, false, paint);

    // Ajustar el mides del text en funció del tipus de dispositiu
    // Si és mòbil, dividim per 20 (més petit relatiu). Si és desktop, per 15 (més gran relatiu).
    final double textSize = side / (isMobile ? 20 : 15);

    // Distància dinàmica per al padding (responsive)
    final double dynamicOffset = textSize * 2.5;
    // Offset horitzontal per etiquetes Dalt/Baix (per allunyar-les de la línia vertical)
    final double verticalAnchorOffset = textSize * 2.0;

    // Crear TextStyle amb mida ajustada
    final TextStyle titleStyle = TextStyle(
        color: Colors.black, fontSize: textSize, fontWeight: FontWeight.normal);
    final TextStyle valueStyle = TextStyle(
        color: Colors.black, fontSize: textSize, fontWeight: FontWeight.bold);

    // Mostrar els textos utilitzant el `Map`
    if (values.length >= 4) {
      // 0: Dalt (Inici Arc)
      // 1: Baix (Final Arc)
      final arcTop = Offset(arcCenter.dx, arcCenter.dy - arcRadius);
      final arcBottom = Offset(arcCenter.dx, arcCenter.dy + arcRadius);

      _drawText(
          canvas,
          values.keys.elementAt(0),
          values.values.elementAt(0),
          arcTop + Offset(-verticalAnchorOffset, 0),
          titleStyle,
          valueStyle); // Padding esquerra
      _drawText(
          canvas,
          values.keys.elementAt(1),
          values.values.elementAt(1),
          arcBottom + Offset(-verticalAnchorOffset, 0),
          titleStyle,
          valueStyle); // Padding esquerra

      // 2: Dreta (Final Fletxa)
      // 3: Esquerra (Inici Fletxa / Centre Arc)
      _drawText(
          canvas,
          values.keys.elementAt(2),
          values.values.elementAt(2),
          arrowEnd + Offset(dynamicOffset, 0),
          titleStyle,
          valueStyle); // Padding dreta (responsive)
      _drawText(
          canvas,
          values.keys.elementAt(3),
          values.values.elementAt(3),
          arrowStart + Offset(-dynamicOffset, 0),
          titleStyle,
          valueStyle); // Padding esquerra (responsive)
    }
  }

  void _drawText(Canvas canvas, String key, int value, Offset offset,
      TextStyle titleStyle, TextStyle valueStyle) {
    final reducedValue = reduceToSingleDigit(value);
    final bool masterNumber = isMasterNumber(reducedValue);

    final TextSpan titleSpan = TextSpan(text: key, style: titleStyle);

    // Eliminem el \n inicial per controlar nosaltres la posició vertical
    final TextSpan valueSpan = TextSpan(
      text: masterNumber
          ? '$reducedValue/${reduceToSingleDigitResult(reducedValue)}'
          : '$reducedValue',
      style: masterNumber
          ? valueStyle.copyWith(
              color: Colors.red,
              backgroundColor: Colors.yellow) // Resaltar números mestres
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

    // Càlcul de l'alçada total i gap
    final double gap =
        titleStyle.fontSize! * 0.1; // Espai entre títol i text (30% de la font)
    final double totalHeight = titlePainter.height + gap + valuePainter.height;

    // Calcular l'offset d'inici vertical (centrat en el punt 'offset')
    final double startY = offset.dy - (totalHeight / 2);

    // Dibuixar el text títol (centrat horitzontalment)
    titlePainter.paint(
        canvas, Offset(offset.dx - (titlePainter.width / 2), startY));

    // Dibuixar el text del valor (centrat horitzontalment, a sota del títol)
    valuePainter.paint(
        canvas,
        Offset(offset.dx - (valuePainter.width / 2),
            startY + titlePainter.height + gap));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
