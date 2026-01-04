import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../numerology_calculation_service.dart';

class PdfHelper {
  static pw.Widget formatNumber(int value, {double fontSize = 10}) {
    int reduced = reduceToSingleDigit(value);
    bool master = isMasterNumber(reduced);

    // Logic: if value == reduced, show just value. If value != reduced (e.g. 11/2), show both.
    String text;
    if (value == reduced) {
      text = '$value';
    } else {
      text = '$value/$reduced';
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: master
          ? pw.BoxDecoration(
              color: PdfColors.yellow,
              borderRadius: pw.BorderRadius.circular(4))
          : null,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: fontSize,
          color: master ? PdfColors.red : PdfColors.black,
        ),
      ),
    );
  }

  static pw.Widget buildInfoBox(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('$label:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Text(value, style: pw.TextStyle(fontSize: 8)),
        )
      ],
    );
  }
}
