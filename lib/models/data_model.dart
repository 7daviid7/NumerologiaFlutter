import 'package:flutter/foundation.dart';
import '../services/numerology_calculation_service.dart'; 

class DataModel with ChangeNotifier {
  late String name;
  late String date;
  late Map<String, int> mapPersonalidad;
  late Map<String, int> mapVida;
  late Map<String, int> mapDesafio;
  late Map<String, int> mapHerencies;
  late Map<String, int> mapPrimerArc;
  late Map<String, int> mapSegonArc;
  late Map<String, List<List<int>>> taula;

  void setData(String name, String date) {
    this.name = name;
    this.date = date;
    _calculateValues();
    notifyListeners();
  }

  void _calculateValues() {
    initVariables();
    final results = calculateValues(name, date);
    taula = calculsTaula(name);

    List<String> personalidad = ['Alma','Expresión','Personalidad','Equilibrio',
      'Misión','Iniciacio','Fuerza'];
    List<String> camiDeVida = ['Camino de Vida','Formación','Producción','Cosecha',
      'Fuerza','Realizacion1','Realizacion2','Total','Realizacion3','Any Personal', 'Any1', 'Any2','Any3'];
    List<String> desafio = ['Desafio1', 'Desafio2', 'Desafio3'];
    List<String> herencies = ['HHP', 'NCS', 'DM', 'EJE', 'MF', 'MS', 'MFE'];
    List<String> primerArc = ['NL', 'Expresión', 'Apertura', 'Desarrollar', ];
    List<String> segonArc = ['NL', 'Alma', 'Renacer','Evolutivo', ];

    mapPersonalidad = valors(results, personalidad);
    mapVida = valors(results, camiDeVida);
    mapDesafio = valors(results, desafio);
    mapHerencies = valors(results, herencies);
    mapPrimerArc = valors(results, primerArc);
    mapSegonArc = valors(results, segonArc);
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
}
