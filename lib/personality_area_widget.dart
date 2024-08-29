import 'package:flutter/material.dart';

class PersonalityAreaWidget extends StatelessWidget {
  final Map<String, int> personalityValues;

  PersonalityAreaWidget({required this.personalityValues});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0), // Redueix encara més el padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0), // Redueix la curvatura
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Títol General
          Text(
            'Àrees de la Personalitat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Mida reduïda del text
          ),
          SizedBox(height: 8), // Redueix l'espai vertical
          // CustomPaint per les línies
          CustomPaint(
            painter: _ConnectorPainter(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Expresió
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPersonalityCircle('Expresió', personalityValues['Expresión'] ?? 0),
                      ],
                    ),
                    SizedBox(height: 12), // Redueix l'espai vertical
                    // Alma i Personalitat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPersonalityCircle('Alma', personalityValues['Alma'] ?? 0),
                        _buildPersonalityCircle('Personalitat', personalityValues['Personalidad'] ?? 0),
                      ],
                    ),
                    SizedBox(height: 24), // Redueix l'espai vertical
                    // Equilibri, Fuerza i Iniciació
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPersonalitySquare('Equilibri', personalityValues['Equilibrio'] ?? 0),
                        _buildPersonalitySquare('Fuerza', personalityValues['Fuerza'] ?? 0),
                        _buildPersonalitySquare('Iniciació', personalityValues['Iniciacio'] ?? 0),
                      ],
                    ),
                    SizedBox(height: 12), // Redueix l'espai vertical
                    // Missió
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPersonalityCircle('Missió', personalityValues['Misión'] ?? 0),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalitySquare(String label, int value) {
    return Container(
      width: 60, // Redueix l'amplada del quadrat
      height: 50, // Redueix l'alçada del quadrat
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(4.0), // Redueix la curvatura
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Redueix la mida del text
          ),
          SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Redueix la mida del text
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityCircle(String label, int value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20, // Redueix el radi del cercle
          backgroundColor: Colors.blue[100],
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Redueix la mida del text
          ),
        ),
        SizedBox(height: 4), // Redueix l'espai entre el cercle i el text
        Text(
          label,
          style: TextStyle(fontSize: 10), // Redueix la mida del text
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
    final Offset expOffset = Offset(size.width / 2, 24); // Expresió
    final Offset almaOffset = Offset(size.width / 3, size.height / 2 - 30); // Alma
    final Offset personalitatOffset = Offset(2 * size.width / 3, size.height / 2 - 40); // Personalitat
    final Offset missioOffset = Offset(size.width / 2, size.height - 24); // Missió

    // Dibuixar línies connectores
    canvas.drawLine(expOffset, almaOffset, paint);
    canvas.drawLine(expOffset, personalitatOffset, paint);
    canvas.drawLine(almaOffset, missioOffset, paint);
    canvas.drawLine(personalitatOffset, missioOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
