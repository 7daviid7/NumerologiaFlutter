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
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Lista de posiciones fijas
    final List<Offset> posiciones = [
      Offset(size.width * 0.59, size.height-600),  // CAP DRET
      Offset(size.width * 0.43, size.height -600),  // CAP ESQUERRE
      Offset(size.width * 0.2, size.height-520),  // BRAÇ ESQUERRE
      Offset(size.width * 0.35, size.height-400),  // PANXA ESQUERRE
      Offset(size.width * 0.25, size.height-200),  // CAMA ESQUERRE
      Offset(size.width * 0.515, size.height-260),  // CADERA
      Offset(size.width * 0.8, size.height -200),  // CAMA DRETA
      Offset(size.width * 0.65, size.height -400),  // PANXA DRETA
      Offset(size.width * 0.8, size.height -520),  // BRAÇ DRET
    ];

    mapFigura.forEach((key, value) {
      final posicion = posiciones[key - 1]; // Obtenemos la posición fija

      // Dibujamos un círculo de fondo
      final paint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawCircle(posicion, 15, paint);

      // Pintamos el número
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

