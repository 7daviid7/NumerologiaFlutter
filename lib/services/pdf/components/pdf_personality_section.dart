import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../pdf_helper.dart';

class PdfPersonalitySection {
  static pw.Widget build(Map<String, int> personalityValues) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(7),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(4)),
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          // Left Column
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            _buildSquare('Equilibri', personalityValues['Equilibrio'] ?? 0),
            pw.SizedBox(height: 5),
            _buildSquare('Força', personalityValues['Fuerza'] ?? 0),
          ]),
          pw.SizedBox(width: 10),
          // Center Column
          pw.Expanded(
              child: pw.Stack(children: [
            // Connections
            pw.Positioned.fill(
              child: pw.CustomPaint(
                painter: (canvas, size) {
                  double cx = size.x / 2;
                  // Inverting Y coordinates because PDF origin is bottom-left
                  // Adjusted offsets for smaller scale
                  double topY = size.y - 30; // High Y (Top)
                  double midY = size.y - 80; // Mid Y
                  double botY = size.y - 130; // Low Y (Bottom)

                  canvas.setColor(PdfColors.grey400);
                  canvas.setLineWidth(1);

                  // Expresión (Top) to others
                  canvas.drawLine(cx, topY, cx, botY); // To Misión
                  canvas.drawLine(cx, topY, size.x * 0.25, midY); // To Alma
                  canvas.drawLine(
                      cx, topY, size.x * 0.75, midY); // To Personalidad
                  canvas.strokePath();
                },
              ),
            ),
            // Content
            pw.Column(children: [
              pw.Text('Àrees de la Personalitat',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 5),
              _buildCircle('Expresió', personalityValues['Expresión'] ?? 0),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Expanded(
                        child: _buildCircle(
                            'Alma', personalityValues['Alma'] ?? 0)),
                    pw.Expanded(
                        child: _buildCircle('Personalitat',
                            personalityValues['Personalidad'] ?? 0)),
                  ]),
              pw.SizedBox(height: 5),
              _buildCircle('Missió', personalityValues['Misión'] ?? 0),
            ])
          ])),
          pw.SizedBox(width: 10),
          // Right Column
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            _buildSquare('Iniciació', personalityValues['Iniciacio'] ?? 0),
          ]),
        ]));
  }

  static pw.Widget _buildSquare(String label, int value) {
    return pw.Container(
        width: 45,
        height: 40,
        decoration: pw.BoxDecoration(
          color: PdfColors.blue100,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw
            .Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
          PdfHelper.formatNumber(value),
        ]));
  }

  static pw.Widget _buildCircle(String label, int value) {
    return pw.Column(children: [
      if (label == 'Expresió') pw.Text(label, style: pw.TextStyle(fontSize: 7)),
      pw.Container(
          width: 40,
          height: 40,
          alignment: pw.Alignment.center,
          decoration: const pw.BoxDecoration(
              color: PdfColors.blue100, shape: pw.BoxShape.circle),
          child: PdfHelper.formatNumber(value)),
      if (label != 'Expresió') pw.Text(label, style: pw.TextStyle(fontSize: 7)),
    ]);
  }
}
