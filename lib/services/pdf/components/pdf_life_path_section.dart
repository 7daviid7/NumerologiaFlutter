import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../pdf_helper.dart'; // Ensure PdfHelper is accessible
import 'pdf_personality_section.dart'; // Reusing _buildSquare logic (but it is private there)
// Actually I should duplicate the square builder or make it public in Helper.
// Let's make a local helper for now or just duplicate code to avoid tight coupling for small UI bits.

class PdfLifePathSection {
  static pw.Widget build(Map<String, int> values, String date) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(4)),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left Side: Graph
            pw.Expanded(
              child: pw.Stack(children: [
                // Connections
                pw.Positioned.fill(
                    child: pw.CustomPaint(painter: (canvas, size) {
                  double w = size.x;
                  // Inverting Y coordinates
                  // Adjusted offsets for smaller scale
                  double y1 = size.y - 35; // Top
                  double y2 = size.y - 80; // Mid
                  double y3 = size.y - 125; // Bot

                  canvas.setColor(PdfColors.grey400);
                  canvas.setLineWidth(1);

                  // Row 1 Center
                  double x1 = w / 2;

                  // Row 2 Centers (3 items expanded: 1/6, 3/6, 5/6)
                  double x2a = w * (1 / 6);
                  double x2b = w * (3 / 6);
                  double x2c = w * (5 / 6);

                  // Row 3 Centers (4 items expanded: 1/8, 3/8, 5/8, 7/8)
                  double x3a = w * (1 / 8);
                  double x3b = w * (3 / 8);
                  double x3c = w * (5 / 8);
                  double x3d = w * (7 / 8);

                  // Draw lines 1 -> 2
                  canvas.drawLine(x1, y1, x2a, y2);
                  canvas.drawLine(x1, y1, x2b, y2);
                  canvas.drawLine(x1, y1, x2c, y2);
                  canvas.strokePath();

                  // Draw lines 2 -> 3
                  // Formació (x2a) -> R1 (x3a)
                  canvas.drawLine(x2a, y2, x3a, y3);
                  // Producció (x2b) -> R2 (x3b) & R3 (x3c)
                  canvas.drawLine(x2b, y2, x3b, y3);
                  canvas.drawLine(x2b, y2, x3c, y3);
                  // Cosecha (x2c) -> R4 (x3d)
                  canvas.drawLine(x2c, y2, x3d, y3);
                  canvas.strokePath();
                })),
                // Content
                pw.Column(children: [
                  pw.Text('Camí de vida',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.SizedBox(height: 5),
                  // Top: Camino de Vida
                  pw.Row(children: [
                    pw.Spacer(),
                    _buildSquare('Camí de Vida', values['Camino de Vida'] ?? 0),
                    pw.Spacer(),
                  ]),
                  pw.SizedBox(height: 5),
                  // Middle: Formacion, Produccion, Cosecha
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildSquare(
                                    'Formació', values['Formación'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildSquare(
                                    'Producció', values['Producción'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildSquare(
                                    'Cosecha', values['Cosecha'] ?? 0))),
                      ]),
                  pw.SizedBox(height: 5),
                  // Bottom: Realizaciones
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                            child: pw.Center(
                                child:
                                    _buildSquare('R1', values['Fuerza'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildSquare(
                                    'R2', values['Realizacion1'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildSquare(
                                    'R3', values['Realizacion2'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildSquare(
                                    'R4', values['Realizacion3'] ?? 0))),
                      ]),
                ])
              ]),
            ),
            pw.SizedBox(width: 10),
            // Right Side: Info Column
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                PdfHelper.buildInfoBox('Data', date),
                pw.SizedBox(height: 5),
                PdfHelper.buildInfoBox('Total', '${values['Total'] ?? 0}'),
                pw.SizedBox(height: 5),
                PdfHelper.buildInfoBox(
                    'Any Personal', '${values['Any Personal'] ?? 0}'),
              ],
            ),
          ],
        ));
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
}
