import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../numerology_calculation_service.dart';

class PdfArcsSection {
  static pw.Widget buildSingleArc(Map<String, int> values, String topKey,
      String bottomKey, String rightKey, String leftKey) {
    // Drawing Dimensions
    const double drawingSize = 115;
    const double padding = 20;
    const double radius = (drawingSize / 2) - padding; // 37.5

    // Container Dimensions (Increased to fit labels)
    const double containerWidth = 180;
    const double containerHeight = 130;

    const double cx = containerWidth / 2;
    const double cy = containerHeight / 2;

    double arrowStartX = cx - radius;
    double arrowEndX = cx + radius;

    return pw.Container(
      width: containerWidth,
      height: containerHeight,
      child: pw.Stack(
        children: [
          // Drawing
          pw.Center(
            child: pw.CustomPaint(
              size: const PdfPoint(containerWidth, containerHeight),
              painter: (PdfGraphics canvas, PdfPoint s) {
                canvas.setColor(PdfColors.black);
                canvas.setLineWidth(2);

                // Arrow Left -> Right
                canvas.drawLine(arrowStartX, cy, arrowEndX, cy);
                canvas.strokePath();

                // Arrow Head
                canvas.drawLine(arrowEndX, cy, arrowEndX - 8, cy - 8);
                canvas.drawLine(arrowEndX, cy, arrowEndX - 8, cy + 8);
                canvas.strokePath();

                // Arc
                double k = 0.552284749831 * radius;

                // Top half arc
                canvas.moveTo(arrowStartX, cy - radius);
                canvas.curveTo(arrowStartX + k, cy - radius,
                    arrowStartX + radius, cy - k, arrowStartX + radius, cy);

                // Bottom half arc
                canvas.curveTo(arrowStartX + radius, cy + k, arrowStartX + k,
                    cy + radius, arrowStartX, cy + radius);

                canvas.strokePath();
              },
            ),
          ),

          // Labels - Using direct positioning relative to calculated points

          // Top Label (Apertura)
          pw.Positioned(
            left: arrowStartX - 50, // Centered roughly 50px left of arrow start
            top: cy - radius - 25,
            child: pw.Container(
              width: 100,
              alignment: pw.Alignment.center,
              child: _buildArcLabel(leftKey, values[leftKey] ?? 0),
            ),
          ),

          // Bottom Label (Desarrollar)
          pw.Positioned(
            left: arrowStartX - 50,
            top: cy + radius + 5,
            child: pw.Container(
              width: 100,
              alignment: pw.Alignment.center,
              child: _buildArcLabel(rightKey, values[rightKey] ?? 0),
            ),
          ),

          // Left Label (NL)
          pw.Positioned(
            left: arrowStartX - 55, // 55px left of start
            top: cy - 15,
            child: pw.Container(
              width: 50,
              alignment: pw.Alignment.centerRight,
              child: _buildArcLabel(bottomKey, values[bottomKey] ?? 0),
            ),
          ),

          // Right Label (Expresion)
          pw.Positioned(
            left: arrowEndX - 20, // 5px right of end
            top: cy - 35,
            child: pw.Container(
              width: 50,
              alignment: pw.Alignment.centerLeft,
              child: _buildArcLabel(topKey, values[topKey] ?? 0),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildArcLabel(String label, int value) {
    int originalValue = value; // Keep original value for master number check
    int reduced = reduceToSingleDigit(value);

    // Check if the original value was a master number (11, 22, 33)
    bool isMaster = isMasterNumber(originalValue);

    String valueText;
    if (originalValue == reduced) {
      valueText = '$originalValue';
    } else if (isMaster) {
      valueText = '$originalValue/$reduced';
    } else {
      valueText = '$originalValue/$reduced';
    }

    // Highlight master numbers with Color (Red) as background is hard
    PdfColor valueColor = isMaster ? PdfColors.red : PdfColors.black;

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(label,
            style: pw.TextStyle(fontSize: 8, color: PdfColors.black)),
        pw.Text(valueText,
            style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: valueColor)),
      ],
    );
  }
}
