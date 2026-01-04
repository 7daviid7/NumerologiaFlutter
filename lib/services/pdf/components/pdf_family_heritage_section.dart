import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../pdf_helper.dart';

class PdfFamilyHeritageSection {
  static pw.Widget build(Map<String, int> values, {bool isVertical = false}) {
    List<MapEntry<String, int>> entries = values.entries.toList();

    if (isVertical) {
      // Vertical Column Layout
      return pw.Container(
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Herències\nFamiliars',
                textAlign: pw.TextAlign.center,
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
            pw.SizedBox(height: 5),
            ...entries.map((entry) {
              return pw.Container(
                width: double.infinity, // Full width of the column
                margin: const pw.EdgeInsets.symmetric(vertical: 2),
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue100,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(entry.key,
                        style:
                            pw.TextStyle(fontSize: 8, color: PdfColors.blue700),
                        textAlign: pw.TextAlign.center),
                    PdfHelper.formatNumber(entry.value),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    } else {
      // Original Grid Layout
      List<pw.Widget> rows = [];
      int itemCount = entries.length;
      int itemsPerRow = 4;
      int rowCount = (itemCount / itemsPerRow).ceil();

      for (int row = 0; row < rowCount; row++) {
        List<pw.Widget> rowItems = [];
        for (int col = 0; col < itemsPerRow; col++) {
          int index = row * itemsPerRow + col;
          if (index < itemCount) {
            String label = entries[index].key;
            int value = entries[index].value;

            rowItems.add(
              pw.Expanded(
                child: pw.Container(
                  margin: const pw.EdgeInsets.all(2),
                  padding: const pw.EdgeInsets.all(4),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(label,
                          style: pw.TextStyle(
                              fontSize: 8, color: PdfColors.blue700)),
                      PdfHelper.formatNumber(value),
                    ],
                  ),
                ),
              ),
            );
          } else {
            rowItems.add(pw.Expanded(child: pw.Container()));
          }
        }
        rows.add(pw.Row(children: rowItems));
      }

      return pw.Container(
          padding: const pw.EdgeInsets.all(5),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Herències Familiars',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.SizedBox(height: 5),
                ...rows
              ]));
    }
  }
}
