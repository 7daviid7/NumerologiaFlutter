import 'package:flutter/material.dart';
import 'numerology_calculation.dart';

class PersonalityAreaWidget extends StatelessWidget {
  final Map<String, int> personalityValues;

  PersonalityAreaWidget({required this.personalityValues});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Ajustos fixos multiplicats per un valor base
        double baseWidth = availableWidth;
        double baseHeight = availableHeight;

        double circleRadius = baseWidth * 0.063; // Radi del cercle
        double squareWidth = baseWidth * 0.15; // Amplada del quadrat
        double squareHeight = baseHeight * 0.2; // Alçada del quadrat
        double textFontSize = baseWidth * 0.02; // Mida de la lletra
        double spacing = baseHeight * 0.02; // Espai entre els elements

        return Container(
          padding: EdgeInsets.all(spacing*1.5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Columna esquerra
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPersonalitySquare(
                    'Equilibri',
                    personalityValues['Equilibrio'] ?? 0,
                    squareWidth,
                    squareHeight,
                    textFontSize,
                  ),
                  SizedBox(height: spacing),
                  _buildPersonalitySquare(
                    'Força',
                    personalityValues['Fuerza'] ?? 0,
                    squareWidth,
                    squareHeight,
                    textFontSize,
                  ),
                ],
              ),
              SizedBox(width: 0),
              // Contingut central
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Títol General
                    Text(
                      'Àrees de la Personalitat',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: textFontSize * 1.5, // Mida del títol
                      ),
                    ),
                    SizedBox(height: 1),
                    // CustomPaint per les línies
                    CustomPaint(
                      size: Size(availableWidth, availableHeight),
                      painter: _ConnectorPainter(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Expresió
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPersonalityCircle(
                                'Expresió',
                                personalityValues['Expresión'] ?? 0,
                                circleRadius,
                                textFontSize,
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          // Alma i Personalitat
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPersonalityCircle(
                                'Alma',
                                personalityValues['Alma'] ?? 0,
                                circleRadius,
                                textFontSize,
                              ),
                              _buildPersonalityCircle(
                                'Personalitat',
                                personalityValues['Personalidad'] ?? 0,
                                circleRadius,
                                textFontSize,
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          // Missió
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPersonalityCircle(
                                'Missió',
                                personalityValues['Misión'] ?? 0,
                                circleRadius,
                                textFontSize,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 0),
              // Columna dreta
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPersonalitySquare(
                    'Iniciació',
                    personalityValues['Iniciacio'] ?? 0,
                    squareWidth,
                    squareHeight,
                    textFontSize,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalitySquare(String label, int value, double width, double height, double fontSize) {
  int reducedValue= reduceToSingleDigit(value); 
  bool masterNumber = isMasterNumber(reducedValue);
  


  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(4.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: fontSize * 1, fontWeight: FontWeight.bold), // Mida del text ajustada
        ),
        SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value/$reducedValue',
                style: TextStyle(
                  fontSize: fontSize * 2, // Mida del text ajustada
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Color del text
                ),
              ),
              if (masterNumber)
                TextSpan(
                  text: '(${reduceToSingleDigitResult(reducedValue)})',
                  style: TextStyle(
                    fontSize: fontSize * 1.2, // Mida del text ajustada
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Color del text reduït
                    backgroundColor: Colors.yellow, // Fons per ressaltar
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildPersonalityCircle(String label, int value, double radius, double fontSize) {
  int reducedValue= reduceToSingleDigit(value); 
  bool masterNumber = isMasterNumber(reducedValue);

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (label == 'Expresió')
        Text(
          label,
          style: TextStyle(fontSize: fontSize * 1),
        ),
      SizedBox(height: 3),
      CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blue[100],
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value/$reducedValue',
                style: TextStyle(
                  fontSize: fontSize * 1.6, // Mida del text ajustada
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Color del text
                ),
              ),
              if (masterNumber)
                TextSpan(
                  text: ' (${reduceToSingleDigitResult(reducedValue)})',
                  style: TextStyle(
                    fontSize: fontSize * 1.6, // Mida del text reduït ajustada
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Color del text reduït
                    backgroundColor: Colors.yellow, // Fons per ressaltar
                  ),
                ),
            ],
          ),
        ),
      ),
      if (label != 'Expresió')
        Column(
          children: [
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: fontSize * 1),
            ),
          ],
        ),
    ],
  );
}
}

class _ConnectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Coordenades relatives per als elements
    final Offset expOffset = Offset(size.width / 2, 25); // Expresió
    final Offset almaOffset = Offset(size.width / 3, size.height / 2 - 25); // Alma
    final Offset personalitatOffset = Offset(2 * size.width / 3, size.height / 2 - 30); // Personalitat
    final Offset missioOffset = Offset(size.width / 2, size.height - 60); // Missió

    // Dibuixar línies connectores
    canvas.drawLine(expOffset, almaOffset, paint);
    canvas.drawLine(expOffset, personalitatOffset, paint);
    canvas.drawLine(expOffset, missioOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
