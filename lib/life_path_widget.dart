import 'package:flutter/material.dart';

class LifePathWidget extends StatelessWidget {
  final Map<String, int> values;
  final String date;

  LifePathWidget({required this.values, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Reduïm el padding
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // Reduïm la mida del text
                ),
                SizedBox(height: 12), // Reduïm l'alçada entre els elements
                CustomPaint(
                  painter: _LifePathPainter(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPersonalityBox('Camí de Vida', values['Camino de Vida'] ?? 0),
                            ],
                          ),
                          SizedBox(height: 20), // Reduïm l'alçada entre els elements
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPersonalityBox('Formació', values['Formación'] ?? 0),
                              _buildPersonalityBox('Producció', values['Producción'] ?? 0),
                              _buildPersonalityBox('Cosecha', values['Cosecha'] ?? 0),
                            ],
                          ),
                          SizedBox(height: 20), // Reduïm l'alçada entre els elements
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPersonalityBox('Realització 1', values['Fuerza'] ?? 0),
                              _buildPersonalityBox('Realització 2', values['Realizacion1'] ?? 0),
                              _buildPersonalityBox('Realització 3', values['Realizacion2'] ?? 0),
                              _buildPersonalityBox('Realització 4', values['Realizacion3'] ?? 0),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20), // Reduïm l'amplada entre el gràfic i la columna de la dreta
          Padding(
            padding: const EdgeInsets.only(right: 20.0), // Reduïm el padding dret
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Reduïm la mida del text
                ),
                SizedBox(height: 4), // Reduïm l'alçada entre els elements
                Container(
                  padding: EdgeInsets.all(6.0), // Reduïm el padding
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(6.0), // Reduïm la curvatura
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 2), // Reduïm l'ombra
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 14), // Reduïm la mida del text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityBox(String label, int value) {
    return Container(
      width: 80, // Reduïm l'amplada
      height: 60, // Reduïm l'alçada
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(6.0), // Reduïm la curvatura
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), // Reduïm la mida del text
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4), // Reduïm l'alçada entre el text i el valor
          Text(
            value.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Reduïm la mida del text
          ),
        ],
      ),
    );
  }
}

class _LifePathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5 // Reduïm l'amplada de les línies
      ..style = PaintingStyle.stroke;

    // Coordenades relatives per als elements
    final Offset camiDeVidaOffset = Offset(size.width / 2, 20); // Ajustem la posició
    final Offset formacioOffset = Offset(size.width / 4, size.height / 2 - 20); // Ajustem la posició
    final Offset produccioOffset = Offset(size.width / 2, size.height / 2 - 20); // Ajustem la posició
    final Offset cosechaOffset = Offset(3 * size.width / 4, size.height / 2 - 20); // Ajustem la posició
    final Offset forzaOffset = Offset(size.width / 4 - 40, size.height - 40); // Ajustem la posició
    final Offset realitzacio1Offset = Offset(size.width / 2.5, size.height - 40); // Ajustem la posició
    final Offset realitzacio2Offset = Offset(size.width / 1.6, size.height - 40); // Ajustem la posició
    final Offset realitzacio3Offset = Offset(size.width / 1.2, size.height - 40); // Ajustem la posició

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
