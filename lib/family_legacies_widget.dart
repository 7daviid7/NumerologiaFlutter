import 'package:flutter/material.dart';
import 'numerology_calculation.dart';

class FamilyHeritageWidget extends StatelessWidget {
  final Map<String, int> values;

  FamilyHeritageWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Ajustem les mides segons l'espai disponible
        double cardMargin = availableHeight * 0.01; // Margin de les targetes
        double cardElevation = availableHeight * 0.005; // Elevació de les targetes
        double iconSize = availableWidth * 0.05; // Mida de la icona
        double textFontSize = availableWidth * 0.028; // Mida del text
        double spacing = availableWidth * 0.01; // Espai entre columnes

        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Herències Familiars',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textFontSize,
                ),
              ),
              SizedBox(height: spacing),
              _buildGridLayout(cardMargin, cardElevation, iconSize, textFontSize, spacing),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGridLayout(
    double cardMargin,
    double cardElevation,
    double iconSize,
    double textFontSize,
    double spacing,
  ) {
    List<Widget> rows = [];
    List<MapEntry<String, int>> entries = values.entries.toList();
    int itemCount = entries.length;
    int itemsPerRow = 4; // Sempre 4 columnes

    for (int row = 0; row < 2; row++) { // Sempre 2 files
      List<Widget> rowItems = [];
      for (int col = 0; col < itemsPerRow; col++) {
        int index = row * itemsPerRow + col;
        if (index < itemCount) {
          String label = entries[index].key;
          int value = entries[index].value;
          int reducedValue = reduceToSingleDigit(value);

          rowItems.add(
            Expanded(
              child: _buildHeritageCard(
                label,
                value,
                reducedValue,
                cardMargin,
                cardElevation,
                iconSize,
                textFontSize,
              ),
            ),
          );

          if (col < itemsPerRow - 1) {
            rowItems.add(SizedBox(width: spacing)); // Espai entre columnes
          }
        }
      }

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowItems,
        ),
      );

      if (row < 1) {
        rows.add(SizedBox(height: spacing)); // Espai entre files
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _buildHeritageCard(
    String label,
    int value,
    int reducedValue,
    double cardMargin,
    double cardElevation,
    double iconSize,
    double textFontSize,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: cardMargin), // Margin vertical
      elevation: cardElevation, // Elevació de la targeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0), // Radius de les cantonades
      ),
      color: Colors.blue[100], // Color blau suau per a la targeta
      child: Padding(
        padding: const EdgeInsets.all(6.0), // Padding intern
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              color: const Color.fromARGB(255, 8, 9, 9), // Color de la icona
              size: iconSize, // Mida de la icona
            ),
            SizedBox(width: 6), // Espai entre icona i text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: textFontSize * 0.6, // Mida del text de l'etiqueta
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600], // Color del text
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$value/$reducedValue',
                    style: TextStyle(
                      fontSize: textFontSize, // Mida del text del valor
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900], // Color del text
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
