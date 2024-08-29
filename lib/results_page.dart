import 'package:flutter/material.dart';
import 'package:numerologia/arc_widget.dart';
import 'package:numerologia/challenges_widget.dart';
import 'package:numerologia/family_legacies_widget.dart';
import 'package:numerologia/numerology_calculation.dart';
import 'data_table.dart';
import 'name_with_values_widget.dart';
import 'personality_area_widget.dart';
import 'life_path_widget.dart';
import 'print_preview_dialog.dart'; // Importa el diàleg de vista prèvia // Importa el servei d'impressió

class ResultsPage extends StatefulWidget {
  final String name;
  final String date;

  ResultsPage({required this.name, required this.date});

  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  late Map<String, int> mapPersonalidad;
  late Map<String, int> mapVida;
  late Map<String, int> mapDesafio;
  late Map<String, int> mapHerencies;
  late Map<String, List<List<int>>> taula;

  final GlobalKey _globalKey = GlobalKey();
  final PrintPreviewDialog _printPreviewDialog = PrintPreviewDialog();

  @override
  void initState() {
    super.initState();

    // Realitza la inicialització i càlculs aquí.
    initVariables();
    final results = calculateValues(widget.name, widget.date);
    taula = calculsTaula(widget.name);
    List<String> personalidad = [
      'Alma',
      'Expresión',
      'Personalidad',
      'Equilibrio',
      'Misión',
      'Iniciacio',
      'Fuerza'
    ];
    List<String> camiDeVida = [
      'Camino de Vida',
      'Formación',
      'Producción',
      'Cosecha',
      'Fuerza',
      'Realizacion1',
      'Realizacion2',
      'Realizacion3'
    ];
    List<String> desafio = ['Desafio1', 'Desafio2', 'Desafio3'];

    List<String> herencies = ['HHP', 'NCS', 'DM', 'EJE', 'MF', 'MS', 'MFE'];

    mapPersonalidad = valors(results, personalidad);
    mapVida = valors(results, camiDeVida);
    mapDesafio = valors(results, desafio);
    mapHerencies = valors(results, herencies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultats'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () => _printPreviewDialog.showPreviewAndPrint(
              context, _globalKey, 'Resultats de Numerologia'), // Crida al diàleg de vista prèvia
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Primer element centrat
              Center(
                child: NameWithValuesWidget(name: widget.name),
              ),
              SizedBox(height: 20),

              // Disseny en tres columnes amb flex ajustats
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3, // Primer columna amb més espai
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2, // Primer element de la columna amb més espai
                            child: DataTableWidget(tableData: taula),
                          ),
                          SizedBox(height: 20),
                          // Dividir l'espai restant en dues columnes amb una fila
                          Expanded(
                            flex: 1, // Segon element de la columna amb més espai
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1, // Espai per ChallengesWidget
                                  child: ChallengesWidget(challenges: mapDesafio),
                                ),
                                SizedBox(width: 20), // Espai entre els dos widgets
                                Expanded(
                                  flex: 3, // Espai per FamilyHeritageWidget
                                  child: FamilyHeritageWidget(values: mapHerencies),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10),
                    Expanded(
                      flex: 2, // Segona columna amb menys espai
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: PersonalityAreaWidget(personalityValues: mapPersonalidad)),
                          SizedBox(height: 5),
                          Expanded(child: LifePathWidget(values: mapVida, date: widget.date)),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1, // Tercera columna amb el menor espai
                      child: ArcWidget(values: mapHerencies),
                    ),
                  ],
                ),
              ),
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
