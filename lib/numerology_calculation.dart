import 'dart:core';
import 'package:diacritic/diacritic.dart';

// Creem un mapa que assigna un valor a cada lletra
final Map<String, int> letterValues = {
  'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6, 'G': 7, 'H': 8, 'I': 9,
  'J': 1, 'K': 2, 'L': 3, 'M': 4, 'N': 5, 'Ñ': 5, 'O': 6, 'P': 7, 'Q': 8, 'R': 9,
  'S': 1, 'T': 2, 'U': 3, 'V': 4, 'W': 5, 'X': 6, 'Y': 7, 'Z': 8,
};
Map<int, int> habitants = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0};
int totalLletres=0; 

void initVariables()
{
  habitants = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0, 9: 0};
  totalLletres=0; 
}



Map<String, int>calculateValues(String name, String data)
{
  Map<String, int>dataMap= calculateDataValues(data); 
  Map<String, int>nameMap=calculateNameValues(name); 
  Map<String, int>herenciesMap=calculateHerencies();

  Map<String, int> results = {};
  results.addAll(dataMap);
  results.addAll(nameMap); 
  results.addAll(herenciesMap); 
  int mision= (results['Camino de Vida']??0) + (results['Expresión']??0); 
  results['Misión'] = mision; 
  int iniciacio=((results['Misión']??0)+(results['Alma']??0)+(results['Dia']??0)); 
  results['Iniciacio'] = iniciacio;
  int valorNl= nl(); 
  results ['NL'] =  valorNl;
  int desarrollar= valorNl+(results['Expresión']??0);
  results ['Desarrollar'] =  desarrollar;
  results ['Apertura'] = desarrollar + desarrollar; 

  int evolutivo= valorNl+(results['Alma']??0);
   results ['Evolutivo'] =  evolutivo;
  results ['Renacer'] = evolutivo + evolutivo; 
  return results;  
}

int nl() 
{
  int nl = nlKarmics();
  if (nl != 0) {
    return nl;
  }

  int sobresurt = nlSobresurt();
  if (sobresurt != 0) {
    return sobresurt;
  }

  int repetits= nlRepetits(); 
  if(repetits!=0)
  {
    return repetits; 
  }

  return nlNoSobresurt();

}

int nlKarmics()
{
  int karmic=0; 
  for(int i=1; i<=habitants.length; i++)
  {
    if(habitants[i]==0)
    {
      karmic+=i; 
    }
  }
  return karmic; 
  
}
List<int>habitantsOrdenats(Map<int,int>habitants)
{
  // Obtenim els valors del mapa i els ordenem en ordre descendent.
  List<int> values = habitants.values.toList();
  values.sort((a, b) => b.compareTo(a));
  return values; 
}

int nlSobresurt()
{
  List<int>values=habitantsOrdenats(habitants); 
  int maxValue = values[0];
  int secondMaxValue = values[1];
  if (maxValue-2>=secondMaxValue)
  {
    return maxValue; 
  }
  else 
  {
    return 0; 
  }
}

int nlNoSobresurt()
{
  List<int>values=habitantsOrdenats(habitants); 
  int maxValue = values[0];
  int secondMaxValue = values[1];
  return maxValue+secondMaxValue; 
}

int nlRepetits() {
  // Crear un mapa per comptar les aparicions de cada valor.
  Map<int, int> comptatges = {};

  // Recorrem els valors del mapa 'habitants'.
  for (int valor in habitants.values) {
    // Si el valor ja existeix en el mapa de comptatge, l'incrementem.
    // Si no, l'afegim al mapa amb un comptatge inicial de 1.
    if (comptatges.containsKey(valor)) {
      comptatges[valor] = comptatges[valor]! + 1;
    } else {
      comptatges[valor] = 1;
    }
  }

  // Trobar el valor més repetit i el seu comptatge.
  int valorMesRepetit = 0;
  int maxComptatge = 0;
  comptatges.forEach((valor, comptatge) {
    if (comptatge > maxComptatge) {
      maxComptatge = comptatge;
      valorMesRepetit = valor;
    }
  });

  // Si el valor més repetit es repeteix més de tres cops, tornem a recórrer 'habitants' per sumar les claus.
  if (maxComptatge >=3) {
    int sumaKeys = 0;
    habitants.forEach((key, value) {
      if (value == valorMesRepetit) {
        sumaKeys += key;
      }
    });
    return sumaKeys;
  }

  // Si no hi ha cap valor que es repeteixi més de tres cops, retornem 0.
  return 0;
}


int recorrerHabitants(int valor)
{
  int result=0; 
  for(int i=valor;i<=valor+3; i++)
  {
    result+=habitants[i]??0; 
  }
  return result; 
}

Map<String,int>calculateHerencies()
{
  int HPP= recorrerHabitants(1); 
  int NCS= recorrerHabitants(6); 
  int MF= 0; 
  int MS= 0; 
  MF=totalLletres+HPP; 
  MS= totalLletres+NCS; 

  return{'HHP': HPP, 'NCS': NCS, 'DM': HPP+NCS, 'EJE': habitants[5]??0, 
    'MF': MF, 'MS': MS, 'MFE': MF+MS};

}

Map<String, int>calculateDataValues(String data)
{
  // Assumeix que la data està en format 'YYYY-MM-DD'
  List<String> parts = data.split('-');

  int any = int.parse(parts[0]); // No es fa servir en aquest exemple
  int mes = int.parse(parts[1]);
  int dia = int.parse(parts[2]);

  String cosecha= any.toString(); 
  int cosecha1=0; 
  for (var char in cosecha.runes) {
    // Converteix el caràcter en un enter
    int digit = int.parse(String.fromCharCode(char));
    cosecha1+= digit;
  }

  // Sumem el dia i el mes
  int fuerza = dia+mes;
  int anyReduit=reduceToSingleDigitResult(any);
  int diaReduit=reduceToSingleDigitResult(dia); 
  int mesReduit=reduceToSingleDigitResult(mes);
  int forzaReduit= reduceToSingleDigitResult(fuerza);
  int total= fuerza+any; 
  int desafio1= (diaReduit-mesReduit).abs(); 
  int desafio2= (diaReduit-anyReduit).abs(); 
  return {'Fuerza': fuerza, 'Camino de Vida': cosecha1+diaReduit+mesReduit, 'Dia':dia, 'Mes': mes, 
  'Any': any, 'Formación': mes, 'Producción':dia, 'Cosecha': cosecha1,
  'Realizacion1': diaReduit+anyReduit,'Realizacion2': forzaReduit+diaReduit+anyReduit,'Realizacion3': mesReduit+anyReduit, 
  'Desafio1': desafio1,'Desafio2': desafio2, 
  'Desafio3': (desafio1-desafio2).abs(),'Total': total };
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
    totalLletres++; 
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

 Map<String, List<List<int>>> calculsTaula(String name) 
{
  //ini taula
  Map<String, List<List<int>>> taula = {
    'Habitants': List.generate(9, (_) => []), // Inicialitza amb 9 llistes buides
    'Matices': List.generate(9, (_) => []),
    'Puentes': List.generate(9, (_) => []),
    'Evolución': List.generate(9, (_) => []),
    'Inconsciente': List.generate(9, (_) => []),
    'Matices ': List.generate(9, (_) => []),
    // Afegiu altres categories si cal
  };

  modificarHabitants(taula); 
  modificarMatices(taula, 'Habitants', 'Matices');
  modificarPuentes(taula);
  modificarEvolucio(taula); 
  modificarInconsciente(taula, name); 
  modificarMatices(taula, 'Inconsciente', 'Matices '); 
  
  return taula;
}

bool isMasterNumber(int number) {
  // Convertir el número en una cadena de caràcters
  if(number<10  )return false; 
  String numStr = number.toString();

  // Comprovar si totes les xifres són iguals
  return numStr.split('').every((digit) => digit == numStr[0]);
}

  int reduceToSingleDigit(int number) {
    // Continuar fins que el número tingui només una xifra o sigui un número mestre
    while (number > 9) {
      // Comprovar si el número és mestre
      if (isMasterNumber(number)) {
        return number;
      }
      // Reduir el número sumant les seves xifres
      number = number.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return number;
  }

int reduceToSingleDigitResult(int number) 
{
  while (number > 9) {
    number = number.toString().split('').map(int.parse).reduce((a, b) => a + b);
  }
  return number;
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
void modificarMatices(Map<String, List<List<int>>>taula, String iteracio, String matices)
{
  int valor1; 
  int valor2; 
  int valor3; 
  int valor4; 
  for(int i=0; i<taula[iteracio]!.length; i++)
  {
    valor1 = reduceToSingleDigit(taula[iteracio]![i][0]);
    if(valor1!=0)
    {
      valor2= reduceToSingleDigit(taula[iteracio]![valor1-1][0]);
      if(valor2!=0)
      {
        valor3= reduceToSingleDigit(taula[iteracio]![valor2-1][0]);
        if(valor3!=0)
        {
          valor4= reduceToSingleDigit(taula[iteracio]![valor3-1][0]); 
        }
        else 
        {
          valor4=0; 
        }
        
      }
      else 
      {
        valor3=0; 
        valor4=0; 
      }
     
    }
    else 
    {
      valor2=0;
      valor3=0; 
      valor4=0; 
    }
    taula[matices]![i] = [valor2, valor3, valor4];
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

void modificarEvolucio(Map<String, List<List<int>>>taula)
{
  for(int i=0; i<taula['Habitants']!.length; i++)
   {
      int evolucio=0; 
      for(int j=1; j<=habitants.length; j++)
      {
        if(habitants[j]==i+1)evolucio++; 
      }
      int valor=evolucio + taula['Habitants']![i][0];  
      taula['Evolución']![i] = [valor];
   }
}

void modificarInconsciente(Map<String, List<List<int>>>taula, String name)
{
  int valor=0; 
  String modName= removeDiacritics(name).replaceAll(' ', '').toUpperCase(); 
  for(int i=0; i<taula['Habitants']!.length; i++)
  {
    if(taula['Habitants']![i][0]==0)
    {
      valor=i+1; 
    }
    else 
    {
       valor=(taula['Habitants']![i][0]); 
    }
    String lletra= modName[valor-1]; 
    int result=letterValues[lletra]??0; 
    taula['Inconsciente']![i] = [result];
  }
}



