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
  late Map<int,int>habitants; 
  late int reduceLife; 
  late int any; 
  late int mes; 
  late int dia; 
  late Map<int, int>mapFigura; 
  late double yin; 
  late double yang; 

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
    habitants=getHabitants();
    habitants[10]=habitants[1]??0; 
    reduceLife= reduceToSingleDigitResult(results['Camino de Vida']??0);
    any= (results['Any']??0)%100;
    mes= (results['Mes']??0);
    dia= (results['Dia']??0);
    valorsFigura();
    yinYang();

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

  void yinYang()
  {
    int any0=any ~/ 10;
    int any1=  any %10; 
    int dia0 = dia ~/ 10;  // Obtenir la primera xifra del dia
    int dia1 = dia % 10;    // Obtenir la segona xifra del dia
    int mes0 = mes ~/ 10;  // Obtenir la primera xifra del mes
    int mes1 = mes % 10;  
    yin=0; 
    yang=0; 

    Set<int> setYin={2, 9, 8, 7};
    Set<int> setYang={1, 3, 4,5};

    mapFigura.forEach((key, value) 
    {
      if(key==dia0 || key==dia1 || key==mes0 || key==mes1 || key==any0 ||key==any1)
      {
        if(setYin.contains(key))
        {
          yin+=_valors(key, dia0, dia1, mes0, mes1, any0, any1);
        }
        else if(setYang.contains(key))
        {
          yang+=_valors(key, dia0, dia1, mes0, mes1, any0, any1);
        }
      }

      if(value== dia0 || value== dia1 || value==mes0 || value==mes1 || value==any0 || value==any1)
      {
        if(setYin.contains(key))
        {
          yin+=_valors(value, dia0, dia1, mes0, mes1, any0, any1)/2;
        }
        else if(setYang.contains(key))
        {
          yang+=_valors(value, dia0, dia1, mes0, mes1, any0, any1)/2;
        }
      }

    });


  }

  int _valors(int key, int dia0, int dia1, int mes0, int mes1, int any0, int any1)
  {
    
    int conditionsMet = 0;
    // Comprova quantes condicions es compleixen
    if (key == dia0) conditionsMet++;
    if (key == dia1) conditionsMet++;
    if (key == mes0) conditionsMet++;
    if (key == mes1) conditionsMet++; 
    if (key == any0) conditionsMet++; 
    if (key == any1) conditionsMet++; 

    return conditionsMet; 
  }
  void valorsFigura()
  {
    mapFigura={};
    int keyValue = reduceLife;
    for (int i = 1; i <= 9; i++) 
    {
      mapFigura[i] = keyValue;
      keyValue = (keyValue % 9) + 1; // increment and wrap around to 1 if it reaches 10
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
}
