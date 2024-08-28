import 'package:flutter/material.dart';

class ChallengesWidget extends StatelessWidget {
  final Map<String, int> challenges; // Map que conté els desafiaments

  ChallengesWidget({required this.challenges});

  @override
  Widget build(BuildContext context) {
    // Ajusta el textStyle segons el teu disseny
    TextStyle smallTextStyle = TextStyle(fontSize: 10); // Mida de font reduïda
    TextStyle smallValueTextStyle = TextStyle(fontSize: 10, color: Colors.blue[900]); // Mida i color del valor

    return Container(
      padding: const EdgeInsets.all(6.0), // Reduïr padding
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0), // Reduïr radi del bord
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Títol General
          Text(
            'Desafiaments',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // Mida del font reduïda
          ),
          SizedBox(height: 8), // Reduïr l’espai entre el títol i la llista
          // Llista de desafiaments
          Column(
            children: challenges.entries.map((entry) {
              return _buildChallengeItem(entry.key, entry.value, smallTextStyle, smallValueTextStyle);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(String challenge, int value, TextStyle textStyle, TextStyle valueTextStyle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0), // Reduïr margin
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Reduïr padding
      decoration: BoxDecoration(
        color: Colors.blue[50], // Ajusta el fons al mateix blau clar
        borderRadius: BorderRadius.circular(4.0), // Reduïr radi del bord
        border: Border.all(color: Colors.blue, width: 1), // Ajusta el color del borde al blau
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ajusta l'espai entre text i valor
        children: [
          // Icona o símbol opcional per a cada desafiament
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.blue[300], // Ajusta el color de la icona
            size: 20, // Reduïr mida de la icona
          ),
          SizedBox(width: 4), // Reduïr espai entre icona i text
          // Nom del desafiament
          Expanded(
            child: Text(
              challenge,
              style: textStyle.copyWith(fontWeight: FontWeight.bold), // Aplicar estil reduït
            ),
          ),
          // Valor del desafiament
          Text(
            value.toString(),
            style: valueTextStyle.copyWith(fontWeight: FontWeight.bold), // Aplicar estil reduït
          ),
        ],
      ),
    );
  }
}
