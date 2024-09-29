import 'package:flutter/material.dart';
import '../services/svg_dinamic_service.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';

class FiguraWidget extends StatelessWidget {
  final String nameSVG;
  final double height; 
  final double width;

  // Constructor que incluye el valor requerido 'name'
  FiguraWidget({required this.nameSVG, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);

    return Stack(
      children: [
        SvgDynamicRenderer(
          width: width,
          height: height,
          svgName: nameSVG,
          dia: dataModel.dia,
          mes: dataModel.mes,
          any: dataModel.any,
          vida: dataModel.reduceLife,
          mapFigura: dataModel.mapFigura,
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: NumerosPainter(dataModel.mapFigura),
          ),
        ),
      ],
    );
  }
}

class NumerosPainter extends CustomPainter {
  final Map<int, int> mapFigura;

  NumerosPainter(this.mapFigura);

  @override
  void paint(Canvas canvas, Size size) {
    // El tamaño del círculo y el tamaño del texto se ajustan en función del tamaño del canvas
    final double circleRadius = size.width * 0.03;
    final double fontSize = size.width * 0.03;

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Lista de posiciones ajustadas de forma proporcional
    final List<Offset> posiciones = [
      Offset(size.width * 0.59, size.height *0.0001),  // CAP DRET
      Offset(size.width * 0.43, size.height * 0.0001),  // CAP ESQUERRE
      Offset(size.width * 0.2, size.height * 0.13),   // BRAÇ ESQUERRE
      Offset(size.width * 0.35, size.height * 0.33),   // PANXA ESQUERRE
      Offset(size.width * 0.25, size.height * 0.67 ),  // CAMA ESQUERRE
      Offset(size.width * 0.515, size.height * 0.58),  // CADERA
      Offset(size.width * 0.8, size.height * 0.67),   // CAMA DRETA
      Offset(size.width * 0.65, size.height * 0.33),   // PANXA DRETA
      Offset(size.width * 0.8, size.height * 0.13),   // BRAÇ DRET
    ];

    mapFigura.forEach((key, value) {
      final posicion = posiciones[key - 1]; // Obtenemos la posición fija correspondiente

      // Dibujamos un círculo de fondo con tamaño dinámico
      final paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawCircle(posicion, circleRadius, paint);

      // Pintamos el número con tamaño dinámico
      textPainter.text = TextSpan(
        text: value.toString(),
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, posicion - Offset(textPainter.width / 2, textPainter.height / 2));
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
