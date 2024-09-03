import 'package:flutter/material.dart';

class ChallengesWidget extends StatelessWidget {
  final Map<String, int> challenges;

  ChallengesWidget({required this.challenges});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Calcula la mida del text en funció de l’amplada disponible
        double fontSize = availableWidth * 0.05; // Ajusta la proporció segons el teu disseny

        return Container(
          width: availableWidth,
          height: availableHeight,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.white,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desafiaments',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 1.5, // Ajusta la mida del títol
                  ),
                ),
                SizedBox(height: 8.0),
                ...challenges.entries.map((entry) {
                  return _buildChallengeItem(
                    entry.key,
                    entry.value,
                    fontSize,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChallengeItem(String challenge, int value, double fontSize) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.blue[300],
            size: fontSize, // Utilitza la mida ajustada per a les icones
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              challenge,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize, // Utilitza la mida ajustada per al text
              ),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize, // Utilitza la mida ajustada per al valor
            ),
          ),
        ],
      ),
    );
  }
}
