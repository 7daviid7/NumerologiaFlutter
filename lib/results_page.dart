import 'package:flutter/material.dart';
import 'package:numerologia/diagram_results.dart';
import 'package:numerologia/numerology_calculation.dart';
import 'data_table.dart';
import 'name_with_values_widget.dart'; // Importar el nuevo archivo

class ResultsPage extends StatelessWidget {
  final String name;
  final String date;

  ResultsPage({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    initVariables();
    final results = calculateValues(name, date);
    final taula = calculsTaula(name);
    

    return Scaffold(
      appBar: AppBar(title: Text('Resultats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NameWithValuesWidget(name: name), // Utilitzem el nou widget
            SizedBox(height: 20),
            Expanded(
              child: DataTableWidget(tableData: taula), // Aquí s'integra la taula
            ),
          ],
        ),
      ),
    );
  }
}
