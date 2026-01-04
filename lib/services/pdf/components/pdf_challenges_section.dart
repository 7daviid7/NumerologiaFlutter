import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:math' as math;

class PdfChallengesSection {
  static pw.Widget build(Map<String, int> challenges) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          pw.Text('Desafiaments',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          pw.SizedBox(height: 10),
          pw.Expanded(
            child: pw.LayoutBuilder(
              builder: (context, constraints) {
                if (constraints == null) return pw.Container();

                double size =
                    math.min(constraints.maxWidth, constraints.maxHeight);
                // Ensure non-zero
                if (size <= 0) size = 100;

                double fontSize = 10;

                return pw.Container(
                  width: size,
                  height: size,
                  child: pw.Stack(
                    children: [
                      // Triangle Background
                      pw.Center(
                        child: pw.CustomPaint(
                          size: PdfPoint(size, size),
                          painter: (PdfGraphics canvas, PdfPoint s) {
                            double w = s.x;
                            double h = s.y;
                            double i = w * 0.1; // 10% inset

                            canvas.setColor(PdfColors.blue100);
                            canvas.setLineWidth(2);

                            // Inverted Triangle
                            // Top Left (High Y)
                            canvas.moveTo(i, h - i);
                            // Top Right (High Y)
                            canvas.lineTo(w - i, h - i);
                            // Bottom Center (Low Y)
                            canvas.lineTo(w / 2, i);
                            // Close
                            canvas.lineTo(i, h - i);
                            canvas.strokePath();
                          },
                        ),
                      ),

                      // Desafio 1 (Top Left)
                      pw.Positioned(
                        top: 8,
                        left: 0,
                        child: _buildChallengeItem(
                          'Desafio 1',
                          challenges['Desafio 1'] ??
                              challenges['Desafio1'] ??
                              0,
                          fontSize,
                        ),
                      ),

                      // Desafio 2 (Top Right)
                      pw.Positioned(
                        top: 8,
                        right: 0,
                        child: _buildChallengeItem(
                          'Desafio 2',
                          challenges['Desafio 2'] ??
                              challenges['Desafio2'] ??
                              0,
                          fontSize,
                        ),
                      ),

                      // Desafio 3 (Bottom Center)
                      pw.Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: pw.Center(
                          child: _buildChallengeItem(
                            'Desafio 3',
                            challenges['Desafio 3'] ??
                                challenges['Desafio3'] ??
                                0,
                            fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildChallengeItem(
      String label, int value, double fontSize) {
    double valueSize = fontSize * 1.5;
    double labelSize = fontSize * 0.8;
    double circlePadding = fontSize * 0.5;

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Container(
          padding: pw.EdgeInsets.all(circlePadding),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: PdfColors.blueAccent, width: 2),
          ),
          child: pw.Text(
            value.toString(),
            style: pw.TextStyle(
              fontSize: valueSize,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: labelSize,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }
}
