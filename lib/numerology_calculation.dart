import 'dart:core';
import 'dart:ffi';
import 'package:diacritic/diacritic.dart';

// Creem un mapa que assigna un valor a cada lletra
final Map<String, int> letterValues = {
  'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9,
  'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'O': 6, 'P': 7, 'Q': 8, 'R': 9,
  'S': 1, 'T': 2, 'U': 3, 'V': 4, 'W': 5, 'X': 6, 'Y': 7, 'Z': 8,
};
Map<int, int> habitants = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0};

void initVariables()
{
  habitants = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0};
}



Map<String, int>calculateValues(String name, String data)
{
  Map<String, int>Data= calculateDataValues(data); 
  Map<String, int>Name=calculateNameValues(name); 
  
  Map<String, int> results = {};
  results.addAll(Data);
  results.addAll(Name); 
  int mision= (results['Camino de Vida']??0) + (results['Expresión']??0); 
  results['Mision'] = mision; 
  int iniciacio=(results['Misio']??0) + (results['Alma']??0) + (results['Camino de Vida']??0); 
  results['Iniciacio'] = iniciacio;
  return results;  

}

Map<String, int>calculateDataValues(String data)
{
  // Assumeix que la data està en format 'YYYY-MM-DD'
  List<String> parts = data.split('-');

  int any = int.parse(parts[0]); // No es fa servir en aquest exemple
  int mes = int.parse(parts[1]);
  int dia = int.parse(parts[2]);

  String cosecha= any.toString(); 
  int Cosecha=0; 
  for (var char in cosecha.runes) {
    // Converteix el caràcter en un enter
    int digit = int.parse(String.fromCharCode(char));
    Cosecha+= digit;
  }


  // Sumem el dia i el mes
  int fuerza = dia + mes;
  int caminoVida= fuerza+any; 

  return {'Fuerza': fuerza, 'Camino de Vida': caminoVida, 
  'Formación': mes, 'Producción':dia, 'Cosecha': Cosecha,
  'Realizacion1': dia+any,'Realizacion2': fuerza+dia+any,'Realizacion3': mes+any};
}

Map<String, int> calculateNameValues(String name) 
{
  int alma = 0;
  int personalitat = 0;
  int equilibri=0; 
  

  // Dividim el nom complet en paraules (nom i cognoms)
  List<String> paraules = name.toUpperCase().split(' ');

  // Iterem sobre cada paraula
  for (var paraula in paraules) 
  {
    if (paraula.isNotEmpty) {
      // Obtenim la primera lletra de la paraula
      var primeraLletra = paraula[0];
      // Afegim el valor de la primera lletra al resultat
      equilibri += letterValues[primeraLletra] ?? 0;
    }
  }
   
  // Iterem sobre els caràcters de la cadena
  for (var rune in removeDiacritics(name).replaceAll(' ', '').toUpperCase().runes) {
    var char = String.fromCharCode(rune);
    habitants[letterValues[char]??0]= (habitants[letterValues[char]??0] ?? 0) + 1;
    if (isVowel(char)) {
      alma += letterValues[char] ?? 0;
    } else {
      personalitat += letterValues[char] ?? 0;
    }
  }

  return {'Alma': alma, 'Personalidad': personalitat, 'Equilibrio': equilibri, 
  'Expresión': alma+personalitat};
}

bool isVowel(String char) {
  return 'AEIOU'.contains(char);
}

 Map<String, List<List<int>>> calculsTaula() 
{
  //ini taula
  Map<String, List<List<int>>> taula = {
    'Habitants': List.generate(9, (_) => []), // Inicialitza amb 9 llistes buides
    'Matices': List.generate(9, (_) => []),
    'Puentes': List.generate(9, (_) => []),
    'Evolución': List.generate(9, (_) => []),
    'Inconsciente': List.generate(9, (_) => []),
    // Afegiu altres categories si cal
  };

  modificarHabitants(taula); 
  modificarMatices(taula); 
  
  return taula;
}

void modificarHabitants(Map<String, List<List<int>>>taula)
{
  // Omplir la llista amb els valors del mapa
  habitants.forEach((key, value) {
    int columnIndex = key - 1;
    if (columnIndex < taula['Habitants']!.length) {
      taula['Habitants']![columnIndex] = [value];
    }
  });
}
void modificarMatices(Map<String, List<List<int>>>taula)
{
  for(int i=0; i<taula['Habitants']!.length; i++)
  {
    int valor1 = taula['Habitants']![i][0];
    int valor2= taula['Habitants']![valor1][0];
    int valor3= taula['Habitants']![valor2][0];
    int valor4= taula['Habitants']![valor3][0]; 
    
    taula['Matices']![i] = [valor2, valor3, valor4];

  }
}
void modificarPuentes(Map<String, List<List<int>>>taula)
{
   for(int i=0; i<taula['Habitants']!.length; i++)
   {
      int valor= (taula['Habitants']![i][0]-(i+1)).abs(); 
      taula['Puentes']![i] = [valor];
   }
}

