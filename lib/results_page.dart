import 'package:flutter/material.dart';
import 'package:numerologia/numerology_calculation.dart';
import 'circle_painter_with_lines.dart';
import 'data_table.dart';

class ResultsPage extends StatelessWidget {
  final String name;
  final String date;

  ResultsPage({required this.name, required this.date});

  @override
  Widget build(BuildContext context) {
    final results = calculateValues(name, date);
    


    return Scaffold(
      appBar: AppBar(title: Text('Resultats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomPaint(
              size: Size(100, 100),
              painter: CirclePainterWithLines(results['vowelSum'] ?? 0, 'Vocals'),
            ),
            CustomPaint(
              size: Size(100, 100),
              painter: CirclePainterWithLines(
                results['consonantSum'] ?? 0,
                'Consonants',
                nextCirclePosition: Offset(50, 100),
              ),
            ),
            CustomPaint(
              size: Size(100, 100),
              painter: CirclePainterWithLines(5, 'Resultat', nextCirclePosition: null),
            ),
            DataTableWidget(tableData: tableData),

          ],
        ),
      ),
    );
  }
}
