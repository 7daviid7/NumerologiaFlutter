import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../models/data_model.dart';
import '../services/numerology_calculation_service.dart';
import 'package:numerologia/constants/svg_constants_identifiers.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:math' as math;

class PrintService {
  Future<void> printFullReportPdf(DataModel data) async {
    final pdf = pw.Document();

    // We can also just calculate specific missing values if they are not in the maps using service,
    // but DataModel should have them.

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildNameWidget(data.name),
            pw.SizedBox(height: 30),

            // Main Desktop Layout 5:3:1
            pw.Container(
              height: 400, // Fixed height to allow inner Expanded to work
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  // COLUMN 1 (Flex 5)
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Results Table (Flex 5)
                        pw.Expanded(
                          flex: 5,
                          child: _buildResultsTable(data.taula),
                        ),
                        pw.SizedBox(height: 10),
                        // Challenges & Arcs Row (Flex 3)
                        pw.Expanded(
                          flex: 3,
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                            children: [
                              // Triangle Challenges (Flex 1)
                              pw.Expanded(
                                flex: 1,
                                child: pw.Center(
                                  child: _buildChallenges(data.mapDesafio),
                                ),
                              ),
                              pw.SizedBox(width: 5),
                              // Arcs (Flex 3) - Grouped in Bordered Container
                              pw.Expanded(
                                flex: 3,
                                child: pw.Container(
                                  padding: const pw.EdgeInsets.all(5),
                                  decoration: pw.BoxDecoration(
                                    border:
                                        pw.Border.all(color: PdfColors.black),
                                    borderRadius: pw.BorderRadius.circular(
                                        4), // Matching radius 8 roughly scaled
                                  ),
                                  child: pw.Row(
                                    children: [
                                      pw.Expanded(
                                        child: _buildSingleArc(
                                            data.mapPrimerArc,
                                            'Apertura',
                                            'Desarrollar',
                                            'Expresión',
                                            'NL'),
                                      ),
                                      pw.SizedBox(width: 10),
                                      pw.Expanded(
                                        child: _buildSingleArc(
                                            data.mapSegonArc,
                                            'Renacer',
                                            'Evolutivo',
                                            'Alma',
                                            'NL'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 5),

                  // COLUMN 2 (Flex 3)
                  pw.Expanded(
                    flex: 3,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: _buildPersonalityArea(data.mapPersonalidad),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Expanded(
                          child: _buildLifePath(data.mapVida, data.date),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 5),

                  // COLUMN 3 (Flex 1)
                  pw.Expanded(
                    flex: 1,
                    child: _buildFamilyHeritage(data.mapHerencies,
                        isVertical: true),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Numerologia_${data.name}.pdf',
    );
  }

  pw.Widget _buildNameWidget(String name) {
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

  pw.Widget _buildResultsTable(Map<String, List<List<int>>> tableData) {
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

  pw.Widget _buildChallenges(Map<String, int> challenges) {
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
                        child: _buildChallengeItemPDF(
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
                        child: _buildChallengeItemPDF(
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
                          child: _buildChallengeItemPDF(
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

  pw.Widget _buildChallengeItemPDF(String label, int value, double fontSize) {
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
            // No shadow support in simple BoxDecoration for PDF usually without more complex work
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

  pw.Widget _buildFamilyHeritage(Map<String, int> values,
      {bool isVertical = false}) {
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
                    _formatNumber(entry.value),
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
                      _formatNumber(value),
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

  pw.Widget _buildPersonalityArea(Map<String, int> personalityValues) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(7),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(4)),
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          // Left Column
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            _buildPersonalitySquarePDF(
                'Equilibri', personalityValues['Equilibrio'] ?? 0),
            pw.SizedBox(height: 5),
            _buildPersonalitySquarePDF(
                'Força', personalityValues['Fuerza'] ?? 0),
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
              _buildPersonalityCirclePDF(
                  'Expresió', personalityValues['Expresión'] ?? 0),
              pw.SizedBox(height: 5),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Expanded(
                        child: _buildPersonalityCirclePDF(
                            'Alma', personalityValues['Alma'] ?? 0)),
                    pw.Expanded(
                        child: _buildPersonalityCirclePDF('Personalitat',
                            personalityValues['Personalidad'] ?? 0)),
                  ]),
              pw.SizedBox(height: 5),
              _buildPersonalityCirclePDF(
                  'Missió', personalityValues['Misión'] ?? 0),
            ])
          ])),
          pw.SizedBox(width: 10),
          // Right Column
          pw.Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            _buildPersonalitySquarePDF(
                'Iniciació', personalityValues['Iniciacio'] ?? 0),
          ]),
        ]));
  }

  pw.Widget _buildPersonalitySquarePDF(String label, int value) {
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
          _formatNumber(value),
        ]));
  }

  pw.Widget _buildPersonalityCirclePDF(String label, int value) {
    return pw.Column(children: [
      if (label == 'Expresió') pw.Text(label, style: pw.TextStyle(fontSize: 7)),
      pw.Container(
          width: 40,
          height: 40,
          alignment: pw.Alignment.center,
          decoration: const pw.BoxDecoration(
              color: PdfColors.blue100, shape: pw.BoxShape.circle),
          child: _formatNumber(value)),
      if (label != 'Expresió') pw.Text(label, style: pw.TextStyle(fontSize: 7)),
    ]);
  }

  pw.Widget _buildLifePath(Map<String, int> values, String date) {
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
                    _buildPersonalitySquarePDF(
                        'Camí de Vida', values['Camino de Vida'] ?? 0),
                    pw.Spacer(),
                  ]),
                  pw.SizedBox(height: 5),
                  // Middle: Formacion, Produccion, Cosecha
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
                                    'Formació', values['Formación'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
                                    'Producció', values['Producción'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
                                    'Cosecha', values['Cosecha'] ?? 0))),
                      ]),
                  pw.SizedBox(height: 5),
                  // Bottom: Realizaciones
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: [
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
                                    'R1', values['Fuerza'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
                                    'R2', values['Realizacion1'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
                                    'R3', values['Realizacion2'] ?? 0))),
                        pw.Expanded(
                            child: pw.Center(
                                child: _buildPersonalitySquarePDF(
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
                _buildInfoBoxPDF('Data', date),
                pw.SizedBox(height: 5),
                _buildInfoBoxPDF('Total', '${values['Total'] ?? 0}'),
                pw.SizedBox(height: 5),
                _buildInfoBoxPDF(
                    'Any Personal', '${values['Any Personal'] ?? 0}'),
              ],
            ),
          ],
        ));
  }

  pw.Widget _buildInfoBoxPDF(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('$label:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50, // Using blue50 if available, else standard
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(color: PdfColors.grey300),
          ),
          child: pw.Text(value, style: pw.TextStyle(fontSize: 8)),
        )
      ],
    );
  }

  pw.Widget _buildSingleArc(Map<String, int> values, String topKey,
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
              child: _buildArcLabelPDF(leftKey, values[leftKey] ?? 0),
            ),
          ),

          // Bottom Label (Desarrollar)
          pw.Positioned(
            left: arrowStartX - 50,
            top: cy + radius + 5,
            child: pw.Container(
              width: 100,
              alignment: pw.Alignment.center,
              child: _buildArcLabelPDF(rightKey, values[rightKey] ?? 0),
            ),
          ),

          // Left Label (NL)
          pw.Positioned(
            left: arrowStartX - 55, // 55px left of start
            top: cy - 15,
            child: pw.Container(
              width: 50,
              alignment: pw.Alignment.centerRight,
              child: _buildArcLabelPDF(bottomKey, values[bottomKey] ?? 0),
            ),
          ),

          // Right Label (Expresion)
          pw.Positioned(
            left: arrowEndX - 20, // 5px right of end
            top: cy - 35,
            child: pw.Container(
              width: 50,
              alignment: pw.Alignment.centerLeft,
              child: _buildArcLabelPDF(topKey, values[topKey] ?? 0),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildArcLabelPDF(String label, int value) {
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

  pw.Widget _buildArcLabel(String label, int value) {
    return pw.Column(
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10)),
        _formatNumber(value),
      ],
    );
  }

  pw.Widget _formatNumber(int value, {double fontSize = 10}) {
    int reduced = reduceToSingleDigit(value);
    bool master = isMasterNumber(reduced);
    // Logic: if value == reduced, show just value. If value != reduced (e.g. 11/2), show both.
    // If master, allow showing both e.g., 11/2.
    // If normal e.g. 15 -> 6, show 15/6? Start code does.
    // User asked: "si veus que hi ha números que ja estàn reduits, potser no cal ser redundat"

    String text;
    if (value == reduced) {
      text = '$value';
    } else {
      // e.g. 15/6 or 11/2
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

  Future<void> printLifeCyclesPdf(DataModel data) async {
    final pdf = pw.Document();

    // We don't necessarily need profile image here if not used, but let's keep it safe if copied logic.
    // Actually, let's keep it simple.

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(data.name,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text(data.date,
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.grey600)),
              pw.SizedBox(height: 20),
              pw.Text('Cicles de Vida',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildLifeCyclesTable(data),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildLifeCyclesTable(DataModel data) {
    Map<int, int> dataMap = data.habitants;
    int vida = data.reduceLife;
    int any = int.parse(data.date.split('-')[0]);

    List<int> originalKeys = dataMap.keys.toList();
    List<int> originalValues = dataMap.values.toList();
    int vidaIndex = originalKeys.indexOf(vida);

    // Reorder Logic
    List<int> reorderedKeys = [
      ...originalKeys.sublist(vidaIndex, originalKeys.length - 1),
      ...originalKeys.sublist(0, vidaIndex)
    ];

    List<int> reorderedValues = [
      ...originalValues.sublist(vidaIndex, originalValues.length - 1),
      ...originalValues.sublist(0, vidaIndex)
    ];

    List<pw.TableRow> rows = [];

    // Header 1 (Cicles)
    rows.add(pw.TableRow(children: [
      pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text('Cicles',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      pw.SizedBox(), // Spacer col 2
      ...originalKeys.map((k) => pw.Center(
          child: pw.Text(k == 0 ? '(*)' : '$k',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))))
    ]));

    // Header 2 (Habitants)
    rows.add(pw.TableRow(children: [
      pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text('Habitants',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
      pw.SizedBox(),
      ...originalValues
          .map((v) => pw.Center(child: pw.Text(v == 0 ? '(*)' : '$v')))
    ]));

    // Separator or spacing if needed. Here just continuing.

    // Data Rows
    bool exception = false;
    bool highlightFirstCel = false;

    // We iterate through reorderedKeys (rows)
    for (int filaIndex = 0; filaIndex < reorderedKeys.length; filaIndex++) {
      int anyPersonal = reorderedKeys[filaIndex];
      int habitantValue = reorderedValues[filaIndex];

      // Row background color for anyPersonal == 1 ?
      PdfColor? rowBgColor = (anyPersonal == 1)
          ? PdfColors.grey200
          : null; // Approximating transparency

      List<pw.Widget> cells = [];

      // Cell 1: Habitant Value
      cells.add(pw.Container(
          color: rowBgColor,
          padding: const pw.EdgeInsets.all(4),
          child: pw.Center(
              child: pw.Text(habitantValue == 0 ? '(*)' : '$habitantValue'))));

      // Cell 2: Any Personal
      cells.add(pw.Container(
          color: rowBgColor,
          padding: const pw.EdgeInsets.all(4),
          child: pw.Center(
              child: pw.Text(anyPersonal == 0 ? '(*)' : '$anyPersonal'))));

      // Start calculating columns
      int titolAnterior = filaIndex;
      int anyAnterior = filaIndex + any;

      // We need to generate originalKeys.length cells
      for (int colIndex = 0; colIndex < originalKeys.length; colIndex++) {
        int titolActual = titolAnterior;
        int anyActual = anyAnterior;

        titolAnterior += 9;
        anyAnterior += 9;

        bool highlight = false;
        int vidaResults = 0;

        if (exception) {
          vidaResults = vida;
        } else {
          vidaResults = vida - 1;
        }

        int diagonalIndex = (vidaResults + filaIndex) % originalKeys.length;

        if (colIndex == diagonalIndex) {
          highlight = true;
        }

        if (colIndex == 0 && highlightFirstCel) {
          highlight = true;
          highlightFirstCel = false; // Reset
        }

        if (colIndex == originalKeys.length - 1 && colIndex == diagonalIndex) {
          exception = true;
        }

        if (colIndex == originalKeys.length - 2 && colIndex == diagonalIndex) {
          highlightFirstCel = true;
        }

        cells.add(pw.Container(
            color: highlight
                ? PdfColors.red100
                : rowBgColor, // Red for highlight, or row color
            padding: const pw.EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: pw.Column(children: [
              pw.Text('$titolActual',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text('$anyActual', style: pw.TextStyle(fontSize: 8)),
            ])));
      }

      rows.add(pw.TableRow(children: cells));
    }

    return pw.Container(
        child: pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FixedColumnWidth(60), // Habitants
        1: const pw.FixedColumnWidth(40), // Any Personal
        // Others auto or flex
      },
      children: rows,
    ));
  }

  Future<void> printSpiritualFigurePdf(DataModel data) async {
    final pdf = pw.Document();

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

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      print("Error generating Spiritual Figure PDF: $e");
    }
  }

  Future<String> _generateColoredSvg(DataModel data) async {
    final String rawSvg = await rootBundle.loadString('assets/siluetaT.svg');
    final xml.XmlDocument document = xml.XmlDocument.parse(rawSvg);

    int dia0 = data.dia ~/ 10;
    int dia1 = data.dia % 10;
    int mes0 = data.mes ~/ 10;
    int mes1 = data.mes % 10;
    int any0 = data.any ~/ 10; // Following logic from SvgDynamicRenderer
    int any1 = data.any % 10;

    _applySvgColors(
        document, data.mapFigura, dia0, dia1, mes0, mes1, any0, any1);

    return document.toXmlString();
  }

  void _applySvgColors(xml.XmlDocument document, Map<int, int> mapFigura,
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

  String _getPintarColorRed(
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

  String _getPintarColorBlue(
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

  void _setSvgFill(xml.XmlDocument document, int key, String color,
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

  xml.XmlElement? _findElementById(xml.XmlDocument document, String id) {
    try {
      return document.descendants
          .whereType<xml.XmlElement>()
          .firstWhere((element) => element.getAttribute('id') == id);
    } catch (e) {
      return null;
    }
  }

  List<pw.Widget> _buildNumberOverlays(
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

  Future<void> printAiInterpretationPdf(DataModel data) async {
    final pdf = pw.Document();

    try {
      if (data.aiInterpretation == null || data.aiInterpretation!.isEmpty) {
        // Handle empty case
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Text("No s'ha generat cap interpretació encara.",
                    style: pw.TextStyle(fontSize: 20)),
              );
            },
          ),
        );
      } else {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            header: (pw.Context context) => _buildHeader(data.name, data.date),
            build: (pw.Context context) => [
              pw.Header(
                level: 0,
                child: pw.Text('Interpretació IA',
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.deepPurple)),
              ),
              pw.SizedBox(height: 20),
              pw.Paragraph(
                text: data.aiInterpretation!,
                style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
              ),
            ],
            footer: (pw.Context context) {
              return pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                  child: pw.Text(
                      'Pàgina ${context.pageNumber} de ${context.pagesCount}',
                      style: const pw.TextStyle(color: PdfColors.grey)));
            },
          ),
        );
      }

      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save());
    } catch (e) {
      print("Error generating AI Interpretation PDF: $e");
    }
  }

  pw.Widget _buildHeader(String name, String date) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(name,
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          pw.Text(date,
              style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
          pw.SizedBox(height: 10),
          pw.Divider(),
          pw.SizedBox(height: 10),
        ]);
  }
}
