import 'package:flutter/material.dart';
import 'numerology_calculation.dart'; // Importa la funció de reducció

class FamilyHeritageWidget extends StatelessWidget {
  final Map<String, int> values; // Map que conté els valors (HHP, NCS, etc.)

  FamilyHeritageWidget({required this.values});

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
            'Herències Familiars',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 20),
          // Dues columnes amb les cartes
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primera columna
              Expanded(
                child: Column(
                  children: _buildColumnItems(0),
                ),
              ),
              SizedBox(width: 16), // Espai entre les columnes
              // Segona columna
              Expanded(
                child: Column(
                  children: _buildColumnItems(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildColumnItems(int columnIndex) {
    List<Widget> items = [];
    List<MapEntry<String, int>> entries = values.entries.toList();

    for (int i = columnIndex; i < entries.length; i += 2) {
      String label = entries[i].key;
      int value = entries[i].value;
      int reducedValue = reduceToSingleDigit(value); // Redueix el valor

      items.add(_buildHeritageCard(label, value, reducedValue));
    }

    return items;
  }

  Widget _buildHeritageCard(String label, int value, int reducedValue) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.family_restroom,
              color: Colors.blue[300],
              size: 40,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Etiqueta del valor (HHP, NCS, etc.)
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Mostra del valor original i reduït de manera destacada
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$value/$reducedValue',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
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
