import 'package:pdf/widgets.dart' as pw;
import '../../numerology_calculation_service.dart';

class PdfNameSection {
  static pw.Widget build(String name) {
    List<pw.Widget> nameRows = [];
    List<pw.Widget> valueRowsAbove = [];
    List<pw.Widget> valueRowsBelow = [];
    List<pw.Widget> totalRows = [];

    int vocal = 0;
    int consonant = 0;
    double fontSize = 10;
    double valueFontSize = 10;
    double wordSpacing = 20; // Espai entre paraules
    double letterWidth = 17; // Amplada de cada lletra (espai entre lletres)

    for (var i = 0; i < name.length; i++) {
      String char = name[i].toUpperCase();

      if (char == ' ') {
        // Add totals for the word
        totalRows.add(
          pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Vocals: $vocal/${reduceToSingleDigit(vocal)}\n'
              'Consonants: $consonant/${reduceToSingleDigit(consonant)}\n'
              'Total: ${reduceToSingleDigit(vocal + consonant)}',
              style: pw.TextStyle(
                  fontSize: valueFontSize, fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
          ),
        );

        // Add visual spacing
        nameRows.add(pw.SizedBox(width: wordSpacing));
        valueRowsAbove.add(pw.SizedBox(width: wordSpacing));
        valueRowsBelow.add(pw.SizedBox(width: wordSpacing));

        vocal = 0;
        consonant = 0;
        continue;
      }

      int value = letterValues[char] ?? 0;

      // Add letter
      nameRows.add(
        pw.Container(
          width: letterWidth,
          alignment: pw.Alignment.center,
          child: pw.Text(
            char,
            style: pw.TextStyle(fontSize: fontSize),
          ),
        ),
      );

      // Add Value (Above or Below)
      if (isVowel(char)) {
        vocal += value;
        valueRowsAbove.add(
          pw.Container(
            width: letterWidth,
            alignment: pw.Alignment.center,
            child: pw.Text(
              value.toString(),
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: valueFontSize),
            ),
          ),
        );
        valueRowsBelow.add(pw.SizedBox(width: letterWidth)); // Placeholder
      } else {
        consonant += value;
        valueRowsAbove.add(pw.SizedBox(width: letterWidth)); // Placeholder
        valueRowsBelow.add(
          pw.Container(
            width: letterWidth,
            alignment: pw.Alignment.center,
            child: pw.Text(
              value.toString(),
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: valueFontSize),
            ),
          ),
        );
      }
    }

    // Add totals for the last word
    totalRows.add(
      pw.Container(
        alignment: pw.Alignment.center,
        child: pw.Text(
          'Vocals: $vocal/${reduceToSingleDigit(vocal)}\n'
          'Consonants: $consonant/${reduceToSingleDigit(consonant)}\n'
          'Total: ${reduceToSingleDigit(vocal + consonant)}',
          style: pw.TextStyle(
              fontSize: valueFontSize, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
      ),
    );

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: totalRows.map((e) => pw.Expanded(child: e)).toList(),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: valueRowsAbove),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center, children: nameRows),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: valueRowsBelow),
      ],
    );
  }
}
