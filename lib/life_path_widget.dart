import 'package:flutter/material.dart';

class LifePathWidget extends StatelessWidget {
  final Map<String, int> values;
  final String date; // Afegeix una variable per a la data

  LifePathWidget({required this.values, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
                // Títol General
                Text(
                  'Camí de vida',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 20),
                // CustomPaint per les línies
                CustomPaint(
                  painter: _LifePathPainter(),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Camí de Vida
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPersonalityBox('Camí de Vida', values['Camino de Vida'] ?? 0),
                            ],
                          ),
                          SizedBox(height: 40),
                          // Cicles
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildPersonalityBox('Formació', values['Formación'] ?? 0),
                              _buildPersonalityBox('Producció', values['Producción'] ?? 0),
                              _buildPersonalityBox('Cosecha', values['Cosecha'] ?? 0),
                            ],
                          ),
                          SizedBox(height: 40),
                          // Realitzacions
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
          SizedBox(width: 40), // Augmenta l'espai entre el gràfic i la columna de la dreta
          Padding(
            padding: const EdgeInsets.only(right: 50.0), // Afegeix un marge addicional a la dreta
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Títol Data
                Text(
                  'Data:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                // Data
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Canvia la posició de l'ombra
                      ),
                    ],
                  ),
                  child: Center( // Centrar el text de la data
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 16),
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
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Coordenades relatives per als elements
    final Offset camiDeVidaOffset = Offset(size.width / 2, 40); // Camí de Vida
    final Offset formacioOffset = Offset(size.width / 4, size.height / 2); // Formació
    final Offset produccioOffset = Offset(size.width / 2, size.height / 2); // Producció
    final Offset cosechaOffset = Offset(3 * size.width / 4, size.height / 2); // Cosecha

    final Offset forzaOffset = Offset(size.width / 4 - 80, size.height - 80); // Força

    final Offset realitzacio1Offset = Offset(size.width / 2.5, size.height - 80); // Realització 1
    final Offset realitzacio2Offset = Offset(size.width / 1.6, size.height - 80); // Realització 2
    final Offset realitzacio3Offset = Offset(size.width / 1.2, size.height - 80); // Realització 3

    // Dibuixar línies connectores
    canvas.drawLine(camiDeVidaOffset, formacioOffset, paint);
    canvas.drawLine(camiDeVidaOffset, produccioOffset, paint);
    canvas.drawLine(camiDeVidaOffset, cosechaOffset, paint);

    // Connexions per a realitzacions
    canvas.drawLine(formacioOffset, forzaOffset, paint);
    canvas.drawLine(produccioOffset, realitzacio1Offset, paint);
    canvas.drawLine(produccioOffset, realitzacio2Offset, paint);
    canvas.drawLine(cosechaOffset, realitzacio3Offset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
