import 'package:flutter/material.dart';
import 'package:numerologia/numerology_calculation.dart';

class NameWithValuesWidget extends StatelessWidget {
  final String name;

  NameWithValuesWidget({required this.name});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ajustem les mides segons l'espai disponible
        double availableWidth = constraints.maxWidth;

        // Ajusta les mides i espais segons l'espai disponible
        double fontSize = availableWidth/14 * 0.2; // Tamany de la lletra
        double valueFontSize = fontSize * 0.8; // Tamany per als valors
        double letterSpacing = fontSize * 0.3; // Espai entre lletres
        double wordSpacing = fontSize * 2.3; // Espai entre paraules
        double rowSpacing = fontSize * 0.5; // Espai entre files

        // Variables per construir la visualització
        List<Widget> nameRows = [];
        List<Widget> valueRowsAbove = [];
        List<Widget> valueRowsBelow = [];
        List<Widget> totalRows = [];
        List<Widget> currentRow = [];

        int vocal = 0;
        int consonant = 0;

        for (var i = 0; i < name.length; i++) {
          String char = name[i].toUpperCase();

          if (char == ' ') {
            // Afegir el widget per mostrar totals quan es detecta un espai
            totalRows.add(
              Expanded(
                child: Center(
                  child: Text(
                    'Vocals: $vocal/${reduceToSingleDigit(vocal)}\n'
                    'Consonants: $consonant/${reduceToSingleDigit(consonant)}\n'
                    'Total: ${reduceToSingleDigit(vocal + consonant)}',
                    style: TextStyle(fontSize: valueFontSize, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );

            // Afegir espais visuals i netejar les variables per al següent segment
            nameRows.add(SizedBox(width: wordSpacing)); // Espai entre paraules
            valueRowsAbove.add(SizedBox(width: wordSpacing)); // Espai entre paraules
            valueRowsBelow.add(SizedBox(width: wordSpacing)); // Espai entre paraules
            currentRow.add(SizedBox(width: wordSpacing)); // Espai entre paraules

            vocal = 0;
            consonant = 0;
            continue;
          }

          int value = letterValues[char] ?? 0;

          // Afegim la lletra actual
          nameRows.add(Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                char,
                style: TextStyle(fontSize: fontSize, letterSpacing: letterSpacing),
              ),
            ),
          ));

          // Afegim el valor si és vocal o consonant
          if (isVowel(char)) {
            vocal += value;
            valueRowsAbove.add(Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  value.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: valueFontSize),
                ),
              ),
            ));
            valueRowsBelow.add(Expanded(child: SizedBox())); // Espai per la separació
          } else {
            consonant += value;
            valueRowsAbove.add(Expanded(child: SizedBox())); // Espai per la separació
            valueRowsBelow.add(Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  value.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: valueFontSize),
                ),
              ),
            ));
          }

          // Afegir l'espai actual a la fila
          currentRow.add(Expanded(child: SizedBox())); 
        }

        // Afegir el widget per mostrar totals al final
        if (currentRow.isNotEmpty) {
          totalRows.add(
            Expanded(
              child: Center(
                child: Text(
                  'Vocals: $vocal/${reduceToSingleDigit(vocal)}\n'
                  'Consonants: $consonant/${reduceToSingleDigit(consonant)}\n'
                  'Total: ${reduceToSingleDigit(vocal + consonant)}',
                  style: TextStyle(fontSize: valueFontSize, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            // Mostrar els totals a dalt
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: totalRows,
            ),
            SizedBox(height: rowSpacing), // Espai entre files
            // Mostrar les files de noms i valors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: valueRowsAbove,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: nameRows,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: valueRowsBelow,
            ),
          ],
        );
      },
    );
  }
}
