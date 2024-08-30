import 'package:flutter/material.dart';

class ChallengesWidget extends StatelessWidget {
  final Map<String, int> challenges; // Map que conté els desafiaments

  ChallengesWidget({required this.challenges});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Obtenim l'espai disponible
        double availableWidth = constraints.maxWidth;

        // Ajustem les mides i espaiaments basats en l'amplada disponible
        double titleFontSize = availableWidth * 0.08; // Mida del text per al títol com a proporció de l'amplada
        double itemFontSize = availableWidth * 0.06;  // Mida del text per als elements com a proporció de l'amplada
        double iconSize = availableWidth * 0.1;      // Mida de la icona com a proporció de l'amplada
        double spacing = availableWidth * 0.02;        // Espai entre elements com a proporció de l'amplada
        double padding = availableWidth * 0.04;        // Padding com a proporció de l'amplada

        TextStyle titleTextStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: titleFontSize,
        );

        TextStyle itemTextStyle = TextStyle(
          fontSize: itemFontSize,
        );

        TextStyle valueTextStyle = TextStyle(
          fontSize: itemFontSize,
          color: Colors.blue[900],
        );

        return Container(
          padding: EdgeInsets.all(padding), // Padding segons l'espai disponible
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4.0), // Radi fix del bord
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Títol General
              Text(
                'Desafiaments',
                style: titleTextStyle, // Aplicar estil del títol
              ),
              SizedBox(height: spacing), // Espai entre el títol i la llista
              // Llista de desafiaments
              Column(
                children: challenges.entries.map((entry) {
                  return _buildChallengeItem(
                    entry.key,
                    entry.value,
                    itemTextStyle,
                    valueTextStyle,
                    iconSize,
                    spacing,
                    padding,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallengeItem(
    String challenge,
    int value,
    TextStyle textStyle,
    TextStyle valueTextStyle,
    double iconSize,
    double spacing,
    double padding,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacing), // Margin entre elements
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: padding), // Padding entre text i borde
      decoration: BoxDecoration(
        color: Colors.blue[50], // Color de fons
        borderRadius: BorderRadius.circular(4.0), // Radi fix del bord
        border: Border.all(color: Colors.blue, width: 1), // Color del borde
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espai entre text i valor
        children: [
          // Icona per a cada desafiament
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.blue[300], // Color de la icona
            size: iconSize, // Mida de la icona
          ),
          SizedBox(width: spacing), // Espai entre icona i text
          // Nom del desafiament
          Expanded(
            child: Text(
              challenge,
              style: textStyle.copyWith(fontWeight: FontWeight.bold), // Estil del text
            ),
          ),
          // Valor del desafiament
          Text(
            value.toString(),
            style: valueTextStyle.copyWith(fontWeight: FontWeight.bold), // Estil del valor
          ),
        ],
      ),
    );
  }
}
