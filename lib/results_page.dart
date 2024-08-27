import 'package:flutter/material.dart';
import 'package:numerologia/numerology_calculation.dart';
import 'data_table.dart';
import 'name_with_values_widget.dart';
import 'personality_area_widget.dart'; // Importar el nou fitxer

// Assegura't que les classes utilitzades aquí són públiques
class ResultsPage extends StatefulWidget {
  final String name;
  final String date;

  ResultsPage({required this.name, required this.date});

  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  late Map<String, int> mapPersonalidad;
  late Map<String, List<List<int>>> taula;

  @override
  void initState() {
    super.initState();

    // Realitza la inicialització i càlculs aquí.
    initVariables();
    final results = calculateValues(widget.name, widget.date);
    taula = calculsTaula(widget.name);
    List<String> personalidad = ['Alma', 'Expresión', 'Personalidad', 'Equilibrio',
      'Misión', 'Iniciacio', 'Fuerza'];
    mapPersonalidad = valors(results, personalidad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resultats')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NameWithValuesWidget(name: widget.name),
              SizedBox(height: 20),
              DataTableWidget(tableData: taula),
              SizedBox(height: 20),
              PersonalityAreaWidget(personalityValues: mapPersonalidad), // Afegim el nou widget aquí
            ],
          ),
        ),
      ),
    );
  }
}

// Assegura't que aquesta funció és pública
Map<String, int> valors(Map<String, int> results, List<String> keysToTransfer) {
  Map<String, int> valors = {};

  for (var key in keysToTransfer) {
    if (results.containsKey(key)) {
      valors[key] = results[key] ?? 0;
    }
  }
  return valors;
}
