import 'package:flutter/material.dart';

class ChallengesWidget extends StatelessWidget {
  final Map<String, int> challenges; // Map que conté els desafiaments

  ChallengesWidget({required this.challenges});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Títol General
          Text(
            'Desafiaments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 20),
          // Llista de desafiaments
          Column(
            children: challenges.entries.map((entry) {
              return _buildChallengeItem(entry.key, entry.value);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(String challenge, int value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blue[50], // Ajusta el fons al mateix blau clar
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue, width: 2), // Ajusta el color del borde al blau
      ),
      child: Row(
        children: [
          // Icona o símbol opcional per a cada desafiament
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.blue[300], // Ajusta el color de la icona
            size: 30,
          ),
          SizedBox(width: 16),
          // Nom del desafiament
          Expanded(
            child: Text(
              challenge,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Valor del desafiament
          Text(
            value.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[900]), // Color blau més fosc per al text
          ),
        ],
      ),
    );
  }
}
