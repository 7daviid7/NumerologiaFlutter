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
        String cellContent = valueList.isEmpty
            ? 'Sun'
            : valueList.map((value) {
                if (rowTitle == 'Puentes') {
                  if (value == 0) {
                    return '-';
                  } else if (value > 9) {
                    int reducedValue = reduceToSingleDigitResult(value);
                    return '$value / $reducedValue';
                  } else {
                    return value.toString();
                  }
                } else {
                  if (value == 0) {
                    return 'Sun';
                  } else if (value > 9) {
                    int reducedValue = reduceToSingleDigitResult(value);
                    return '$value / $reducedValue';
                  } else {
                    return value.toString();
                  }
                }
              }).join(', ');

        if (cellContent == 'Sun') cellContent = '(*)';

        return pw.Center(
            child: pw.Text(cellContent, style: pw.TextStyle(fontSize: 10)));
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
