import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../numerology_calculation_service.dart';

class PdfResultsTableSection {
  static pw.Widget build(Map<String, List<List<int>>> tableData) {
    // Define headers
    List<pw.Widget> headers = [pw.Text('')];
    int maxColumns = 0;
    if (tableData.isNotEmpty) {
      maxColumns = tableData.values
          .map((listOfLists) => listOfLists.length)
          .fold(0, (prev, element) => element > prev ? element : prev);
    }

    for (int i = 0; i < maxColumns; i++) {
      headers.add(pw.Text('Casa ${i + 1}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)));
    }

    // Define Rows
    List<pw.TableRow> rows = [
      pw.TableRow(
          children: headers
              .map((h) => pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Center(child: h)))
              .toList())
    ];

    for (var entry in tableData.entries) {
      String rowTitle = entry.key;
      List<List<int>> rowValues = entry.value;

      List<pw.Widget> cells = [
        pw.Text(rowTitle,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))
      ];

      cells.addAll(rowValues.map((valueList) {
        List<pw.Widget> children = [];

        if (valueList.isEmpty) {
          children.add(pw.Container(
            width: 8,
            height: 8,
            decoration: const pw.BoxDecoration(
              color: PdfColors.orange,
              shape: pw.BoxShape.circle,
            ),
          ));
        } else {
          for (int i = 0; i < valueList.length; i++) {
            int value = valueList[i];

            if (value == 0) {
              if (rowTitle != 'Puentes') {
                children.add(pw.Container(
                  width: 8,
                  height: 8,
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.orange,
                    shape: pw.BoxShape.circle,
                  ),
                ));
              } else {
                children.add(pw.Text('-', style: pw.TextStyle(fontSize: 10)));
              }
            } else {
              String text;
              if (rowTitle == 'Puentes') {
                if (value > 9) {
                  int reduced = reduceToSingleDigitResult(value);
                  text = '$value / $reduced';
                } else {
                  text = value.toString();
                }
              } else {
                if (value > 9) {
                  int reduced = reduceToSingleDigitResult(value);
                  text = '$value / $reduced';
                } else {
                  text = value.toString();
                }
              }
              children.add(pw.Text(text, style: pw.TextStyle(fontSize: 10)));
            }

            if (i < valueList.length - 1) {
              children.add(pw.Text(', ', style: pw.TextStyle(fontSize: 10)));
            }
          }
        }

        return pw.Center(
            child: pw.Wrap(
          children: children,
          crossAxisAlignment: pw.WrapCrossAlignment.center,
          alignment: pw.WrapAlignment.center,
          runAlignment: pw.WrapAlignment.center,
        ));
      }));

      while (cells.length < maxColumns + 1) {
        cells.add(pw.Text(''));
      }

      rows.add(pw.TableRow(
          children: cells
              .map((c) =>
                  pw.Padding(padding: const pw.EdgeInsets.all(4), child: c))
              .toList()));
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      columnWidths: {0: const pw.FixedColumnWidth(80)},
      children: rows,
    );
  }
}
