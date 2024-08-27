import 'package:flutter/material.dart';

class PersonalityAreaWidget extends StatelessWidget {
  final Map<String, int> personalityValues;

  PersonalityAreaWidget({required this.personalityValues});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Títol General
          Text(
            'Àrees de la Personalitat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 20),
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
                    SizedBox(height: 40),
                    // Alma i Personalitat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPersonalityCircle('Alma', personalityValues['Alma'] ?? 0),
                        _buildPersonalityCircle('Personalitat', personalityValues['Personalidad'] ?? 0),
                      ],
                    ),
                    SizedBox(height: 40),
                    // Equilibri, Fuerza i Iniciació
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPersonalitySquare('Equilibri', personalityValues['Equilibrio'] ?? 0),
                        _buildPersonalitySquare('Fuerza', personalityValues['Fuerza'] ?? 0),
                        _buildPersonalitySquare('Iniciació', personalityValues['Iniciacio'] ?? 0),
                      ],
                    ),
                    SizedBox(height: 40),
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
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildPersonalityCircle(String label, int value) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue[100],
          child: Text(
            value.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Text(label),
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
    final Offset expOffset = Offset(size.width / 2, 40); // Expresió
    final Offset almaOffset = Offset(size.width / 3, size.height / 2); // Alma
    final Offset personalitatOffset = Offset(2 * size.width / 3, size.height / 2); // Personalitat
    final Offset missioOffset = Offset(size.width / 2, size.height - 40); // Missió

    // Dibuixar línies connectores
    canvas.drawLine(expOffset, almaOffset, paint);
    canvas.drawLine(expOffset, personalitatOffset, paint);
    canvas.drawLine(almaOffset, missioOffset, paint);
    canvas.drawLine(personalitatOffset, missioOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
