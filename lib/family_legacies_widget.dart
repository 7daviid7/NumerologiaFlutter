import 'package:flutter/material.dart';
import 'numerology_calculation.dart';

class FamilyHeritageWidget extends StatelessWidget {
  final Map<String, int> values;

  FamilyHeritageWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Herències Familiars',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildGridLayout(3); // 3 Columnes i 2 Files
              } else {
                return _buildGridLayout(4); // 4 Columnes i 2 Files
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridLayout(int columns) {
    int itemsPerColumn = (values.length / columns).ceil();

    List<Widget> columnWidgets = [];
    List<MapEntry<String, int>> entries = values.entries.toList();

    for (int col = 0; col < columns; col++) {
      int startIndex = col * itemsPerColumn;
      int endIndex = startIndex + itemsPerColumn;

      if (endIndex > entries.length) endIndex = entries.length;

      List<Widget> columnItems = [];
      for (int i = startIndex; i < endIndex; i++) {
        String label = entries[i].key;
        int value = entries[i].value;
        int reducedValue = reduceToSingleDigit(value);

        columnItems.add(_buildHeritageCard(label, value, reducedValue));
      }

      columnWidgets.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnItems,
          ),
        ),
      );

      if (col < columns - 1) {
        columnWidgets.add(SizedBox(width: 4)); // Redueix l'espai entre columnes
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnWidgets,
    );
  }

  Widget _buildHeritageCard(String label, int value, int reducedValue) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 2.0), // Redueix l'espai vertical
      elevation: 1, // Redueix l'elevació per un aspecte més pla
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0), // Redueix la curvatura de les cantonades
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0), // Redueix el padding intern
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              color: Colors.blue[300],
              size: 22, // Redueix la mida de la icona
            ),
            SizedBox(width: 6), // Redueix l'espai entre la icona i el text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '$value/$reducedValue',
                    style: TextStyle(
                      fontSize: 16, // Redueix la mida del text
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
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
