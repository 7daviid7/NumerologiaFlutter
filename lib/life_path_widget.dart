import 'package:flutter/material.dart';
import 'package:numerologia/numerology_calculation.dart';
class LifePathWidget extends StatelessWidget {

  final Map<String, int> values;
  final String date;

  LifePathWidget({required this.values, required this.date});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        double boxWidth = availableWidth * 0.17; // Amplada de les caixes
        double boxHeight = availableHeight * 0.22; // Alçada de les caixes
        double spacing = availableHeight * 0.02; // Espai entre els elements
        double textFontSizeTitle = availableWidth * 0.03; // Mida del text del títol
        double textFontSizeDate = availableWidth * 0.03; // Mida del text de la data

        return Container(
          padding: EdgeInsets.all(spacing),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Camí de vida',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textFontSizeTitle),
                    ),
                    SizedBox(height: spacing ),
                    CustomPaint(
                      size: Size(availableWidth, availableHeight * 0.7),
                      painter: _LifePathPainter(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildPersonalityBox(
                                    'Camí de Vida',
                                    values['Camino de Vida'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing * 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildPersonalityBox(
                                    'Formació',
                                    values['Formación'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                  _buildPersonalityBox(
                                    'Producció',
                                    values['Producción'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                  _buildPersonalityBox(
                                    'Cosecha',
                                    values['Cosecha'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing * 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildPersonalityBox(
                                    'Realització 1',
                                    values['Fuerza'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                  _buildPersonalityBox(
                                    'Realització 2',
                                    values['Realizacion1'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                  _buildPersonalityBox(
                                    'Realització 3',
                                    values['Realizacion2'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                  _buildPersonalityBox(
                                    'Realització 4',
                                    values['Realizacion3'] ?? 0,
                                    boxWidth,
                                    boxHeight,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildSmallBox(values['Any1'], spacing, textFontSizeDate), 
                                  _buildSmallBox(values['Any2'], spacing, textFontSizeDate),
                                  _buildSmallBox(values['Any3'], spacing, textFontSizeDate),
                                ]
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing * 2),
              Padding(
                padding: EdgeInsets.only(right: spacing * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textFontSizeDate),
                    ),
                    SizedBox(height: spacing / 2),
                    _buildSmallBox(date, spacing, textFontSizeDate),
                    SizedBox(height: spacing/2),
                    // Nou text per mostrar el total
                   Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textFontSizeDate),
                    ),
                    SizedBox(height: spacing / 2),
                    _buildSmallBox(values['Total'] ?? 0, spacing, textFontSizeDate),
                    SizedBox(height: spacing / 2),
                    Text(
                      'Any Personal:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: textFontSizeDate),
                    ),
                    SizedBox(height: spacing / 2),
                    _buildSmallBox(values['Any Personal'] ?? 0, spacing, textFontSizeDate)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalityBox(String label, int value, double width, double height) {
    double textSizeLabel = width * 0.12; // Mida del text del label
    double textSizeValue = width * 0.24; // Mida del text del valor

    int reducedValue = reduceToSingleDigit(value);
    bool masterNumber = isMasterNumber(reducedValue); // Números mestres
    bool reduce = reducedValue == value; // Comprovació si el valor reduït és igual al valor original

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: textSizeLabel, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0),
          RichText(
            text: TextSpan(
              text: reduce ? '$value   ' : '$value/$reducedValue  ',
              style: TextStyle(fontSize: textSizeValue, fontWeight: FontWeight.bold, color: Colors.black),
              children: masterNumber
                  ? [
                      TextSpan(
                        text: '(${reduceToSingleDigitResult(reducedValue)})',
                        style: TextStyle(
                          fontSize: textSizeValue * 1, // Mida del text reduït ajustada
                          fontWeight: FontWeight.bold,
                          color: Colors.red, // Color del text reduït
                          backgroundColor: Colors.yellow, // Fons per ressaltar
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSmallBox(dynamic value, double spacing, double textFontSizeDate)
{
  return Container(
    padding: EdgeInsets.all(spacing / 2),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(6.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child: Text(
        '$value anys',
        style: TextStyle(fontSize: textFontSizeDate),
      ),
    ),
                     
  );
  
}


class _LifePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Coordenades relatives per als elements
    final Offset camiDeVidaOffset = Offset(size.width / 2, 20);
    final Offset formacioOffset = Offset(size.width / 4, size.height / 2 - 20);
    final Offset produccioOffset = Offset(size.width / 2, size.height / 2 - 20);
    final Offset cosechaOffset = Offset(3 * size.width / 4, size.height / 2 - 20);
    final Offset forzaOffset = Offset(size.width / 4 - 40, size.height - 40);
    final Offset realitzacio1Offset = Offset(size.width / 2.5, size.height - 40);
    final Offset realitzacio2Offset = Offset(size.width / 1.6, size.height - 40);
    final Offset realitzacio3Offset = Offset(size.width / 1.2, size.height - 40);

    // Dibuixar línies connectores
    canvas.drawLine(camiDeVidaOffset, formacioOffset, paint);
    canvas.drawLine(camiDeVidaOffset, produccioOffset, paint);
    canvas.drawLine(camiDeVidaOffset, cosechaOffset, paint);
    canvas.drawLine(formacioOffset, forzaOffset, paint);
    canvas.drawLine(produccioOffset, realitzacio1Offset, paint);
    canvas.drawLine(produccioOffset, realitzacio2Offset, paint);
    canvas.drawLine(cosechaOffset, realitzacio3Offset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
