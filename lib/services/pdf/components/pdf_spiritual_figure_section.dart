import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:numerologia/constants/svg_constants_identifiers.dart';
import 'package:xml/xml.dart' as xml;
import '../../../models/data_model.dart';
import '../../numerology_calculation_service.dart';

class PdfSpiritualFigureSection {
  static Future<void> printToPdf(DataModel data, pw.Document pdf) async {
    try {
      final svgString = await _generateColoredSvg(data);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(data.name,
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text(data.date,
                      style:
                          pw.TextStyle(fontSize: 18, color: PdfColors.grey600)),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Column(children: [
                        pw.Text('Yang: ${data.yang}',
                            style: const pw.TextStyle(fontSize: 14)),
                      ]),
                      pw.SizedBox(width: 20),

                      // Figure Stack
                      pw.Container(
                        height: 400, // Fixed height for PDF
                        width: 350, // Approx aspect ratio
                        child: pw.Stack(
                          children: [
                            pw.SvgImage(svg: svgString, fit: pw.BoxFit.fill),
                            ..._buildNumberOverlays(data.mapFigura, 350, 400),
                          ],
                        ),
                      ),

                      pw.SizedBox(width: 20),
                      pw.Column(children: [
                        pw.Text('Yin: ${data.yin}',
                            style: const pw.TextStyle(fontSize: 14)),
                      ]),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    } catch (e) {
      print("Error generating Spiritual Figure PDF: $e");
    }
  }

  static Future<String> _generateColoredSvg(DataModel data) async {
    final String rawSvg = await rootBundle.loadString('assets/siluetaT.svg');
    final xml.XmlDocument document = xml.XmlDocument.parse(rawSvg);

    int dia0 = data.dia ~/ 10;
    int dia1 = data.dia % 10;
    int mes0 = data.mes ~/ 10;
    int mes1 = data.mes % 10;
    int any0 = data.any ~/ 10;
    int any1 = data.any % 10;

    _applySvgColors(
        document, data.mapFigura, dia0, dia1, mes0, mes1, any0, any1);

    return document.toXmlString();
  }

  static void _applySvgColors(xml.XmlDocument document, Map<int, int> mapFigura,
      int dia0, int dia1, int mes0, int mes1, int any0, int any1) {
    mapFigura.forEach((key, value) {
      if (key == dia0 ||
          key == dia1 ||
          key == mes0 ||
          key == mes1 ||
          key == any0 ||
          key == any1) {
        String color =
            _getPintarColorRed(key, dia0, dia1, mes0, mes1, any0, any1);
        _setSvgFill(document, key, color, isHalf: false);
      }

      if (value == dia0 ||
          value == dia1 ||
          value == mes0 ||
          value == mes1 ||
          value == any0 ||
          value == any1) {
        String color =
            _getPintarColorBlue(value, dia0, dia1, mes0, mes1, any0, any1);
        // FIX: Use key, not value, to identify the body part
        _setSvgFill(document, key, color, isHalf: true);
      }
    });
  }

  static String _getPintarColorRed(
      int key, int dia0, int dia1, int mes0, int mes1, int any0, int any1) {
    int conditionsMet = 0;
    if (key == dia0) conditionsMet++;
    if (key == dia1) conditionsMet++;
    if (key == mes0) conditionsMet++;
    if (key == mes1) conditionsMet++;
    if (key == any0) conditionsMet++;
    if (key == any1) conditionsMet++;

    switch (conditionsMet) {
      case 1:
        return '#FFA07A';
      case 2:
        return '#FF4500';
      case 3:
        return '#B22222';
      case 4:
        return '#8B0000';
      default:
        return '#FFA07A';
    }
  }

  static String _getPintarColorBlue(
      int key, int dia0, int dia1, int mes0, int mes1, int any0, int any1) {
    int conditionsMet = 0;
    if (key == dia0) conditionsMet++;
    if (key == dia1) conditionsMet++;
    if (key == mes0) conditionsMet++;
    if (key == mes1) conditionsMet++;
    if (key == any0) conditionsMet++;
    if (key == any1) conditionsMet++;

    switch (conditionsMet) {
      case 1:
        return '#B0E0E6';
      case 2:
        return '#4682B4';
      case 3:
        return '#1E90FF';
      case 4:
        return '#000080';
      default:
        return '#B0E0E6';
    }
  }

  static void _setSvgFill(xml.XmlDocument document, int key, String color,
      {required bool isHalf}) {
    String baseId = "";
    switch (key) {
      case SvgIdentifiers.CAP_DRET:
        baseId = "CapDret";
      case SvgIdentifiers.CAP_ESQUERRE:
        baseId = "CapEsquerre";
      case SvgIdentifiers.BRAC_ESQUERRE:
        baseId = "BracEsquerre";
      case SvgIdentifiers.PANXA_ESQUERRE:
        baseId = "PanxaEsquerre";
      case SvgIdentifiers.CADERA:
        baseId = "Cadera";
      case SvgIdentifiers.CAMA_ESQUERRE:
        baseId = "CamaEsquerre";
      case SvgIdentifiers.CAMA_DRETA:
        baseId = "CamaDreta";
      case SvgIdentifiers.PANXA_DRETA:
        baseId = "PanxaDreta";
      case SvgIdentifiers.BRAC_DRET:
        baseId = "BracDret";
    }

    String targetId;
    if (isHalf) {
      targetId = 'meitat$baseId';
    } else {
      if (baseId.isNotEmpty) {
        targetId = baseId[0].toLowerCase() + baseId.substring(1);
      } else {
        return;
      }
    }

    final element = _findElementById(document, targetId);
    if (element != null) {
      element.setAttribute('fill', color);
    }
  }

  static xml.XmlElement? _findElementById(xml.XmlDocument document, String id) {
    try {
      return document.descendants
          .whereType<xml.XmlElement>()
          .firstWhere((element) => element.getAttribute('id') == id);
    } catch (e) {
      return null;
    }
  }

  static List<pw.Widget> _buildNumberOverlays(
      Map<int, int> mapFigura, double w, double h) {
    List<pw.Widget> widgets = [];

    // Coordinates (x_ratio, y_ratio_from_top)
    final List<List<double>> coords = [
      [0.59, 0.03], // 1: Cap Dret
      [0.43, 0.03], // 2: Cap Esquerre
      [0.20, 0.13], // 3: Brac Esquerre
      [0.35, 0.33], // 4: Panxa Esquerre
      [0.25, 0.67], // 5: Cama Esquerre
      [0.515, 0.58], // 6: Cadera
      [0.80, 0.67], // 7: Cama Dreta
      [0.65, 0.33], // 8: Panxa Dreta
      [0.80, 0.13], // 9: Brac Dret
    ];

    mapFigura.forEach((key, value) {
      if (key >= 1 && key <= 9) {
        int idx = key - 1;
        double xRatio = coords[idx][0];
        double yRatio = coords[idx][1];

        double left = w * xRatio;
        double top = h * yRatio;

        widgets.add(pw.Positioned(
            left: left - 10,
            top: top - 10,
            child: pw.Container(
                width: 20,
                height: 20,
                decoration: const pw.BoxDecoration(
                    color: PdfColors.black, shape: pw.BoxShape.circle),
                alignment: pw.Alignment.center,
                child: pw.Text('$value',
                    style: const pw.TextStyle(
                        color: PdfColors.white, fontSize: 10)))));
      }
    });

    return widgets;
  }
}
