import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import '../models/data_model.dart';
import '../services/numerology_calculation_service.dart';
import 'package:numerologia/constants/svg_constants_identifiers.dart';
import 'package:xml/xml.dart' as xml;

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
            pw.Header(
              level: 0,
              child: pw.Center(
                child: pw.Text("Informe de Numerologia: ${data.name}",
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Data de naixement: ${data.date}",
                style: const pw.TextStyle(fontSize: 14)),
            pw.Divider(),
            pw.SizedBox(height: 20),

            // 1. Name Analysis
            pw.Text("Anàlisi del Nom",
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
            pw.SizedBox(height: 10),
            _buildNameWidget(data.name),
            pw.SizedBox(height: 30),

            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Taula de Resultats",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 18)),
                    pw.SizedBox(height: 10),
                    _buildResultsTable(data.taula),
                  ]),
              pw.SizedBox(width: 20),
              pw.Expanded(
                child: pw.Column(children: [
                  _buildFamilyHeritage(data.mapHerencies),
                  pw.SizedBox(height: 10),
                  _buildChallenges(data.mapDesafio),
                ]),
              ),
            ]),
            pw.SizedBox(height: 10),

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPersonalityArea(data.mapPersonalidad),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildLifePath(data.mapVida, data.date),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                _buildSingleArc(data.mapPrimerArc, 'Apertura', 'Desarrollar',
                    'NL', 'Expresión'),
                _buildSingleArc(
                    data.mapSegonArc, 'Renacer', 'Evolutivo', 'NL', 'Alma'),
              ],
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

    tableData.entries.forEach((entry) {
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
    });

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
        border: pw.Border.all(),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Desafiaments',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          pw.SizedBox(height: 5),
          ...challenges.entries.map((entry) {
            return pw.Container(
              margin: const pw.EdgeInsets.symmetric(vertical: 2),
              padding: const pw.EdgeInsets.all(4),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue),
                color: PdfColors.blue50,
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('(!)', style: pw.TextStyle(color: PdfColors.blue)),
                  pw.SizedBox(width: 5),
                  pw.Expanded(
                    child: pw.Text(
                      entry.key,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  pw.Text(
                    entry.value.toString(),
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  pw.Widget _buildFamilyHeritage(Map<String, int> values) {
    List<pw.Widget> rows = [];
    List<MapEntry<String, int>> entries = values.entries.toList();
    int itemCount = entries.length;
    int itemsPerRow = 4;

    // We want 2 rows max generally
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
          // Filler for empty cells
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

  pw.Widget _buildPersonalityArea(Map<String, int> personalityValues) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(4)),
        child:
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          // Left Column
          pw.Column(children: [
            _buildPersonalitySquarePDF(
                'Equilibri', personalityValues['Equilibrio'] ?? 0),
            pw.SizedBox(height: 10),
            _buildPersonalitySquarePDF(
                'Força', personalityValues['Fuerza'] ?? 0),
          ]),
          pw.SizedBox(width: 20),
          // Center Column
          pw.Expanded(
              child: pw.Stack(children: [
            // Connections
            pw.Positioned.fill(
              child: pw.CustomPaint(
                painter: (canvas, size) {
                  double cx = size.x / 2;
                  // Inverting Y coordinates because PDF origin is bottom-left
                  double topY = size.y - 40; // High Y (Top)
                  double midY = size.y - 110; // Mid Y
                  double botY = size.y - 180; // Low Y (Bottom)

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
                      fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 10),
              _buildPersonalityCirclePDF(
                  'Expresió', personalityValues['Expresión'] ?? 0),
              pw.SizedBox(height: 10),
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
              pw.SizedBox(height: 10),
              _buildPersonalityCirclePDF(
                  'Missió', personalityValues['Misión'] ?? 0),
            ])
          ])),
          pw.SizedBox(width: 20),
          // Right Column
          pw.Column(children: [
            _buildPersonalitySquarePDF(
                'Iniciació', personalityValues['Iniciacio'] ?? 0),
          ]),
        ]));
  }

  pw.Widget _buildPersonalitySquarePDF(String label, int value) {
    return pw.Container(
        width: 60,
        height: 50,
        decoration: pw.BoxDecoration(
          color: PdfColors.blue100,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw
            .Column(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
          _formatNumber(value),
        ]));
  }

  pw.Widget _buildPersonalityCirclePDF(String label, int value) {
    return pw.Column(children: [
      if (label == 'Expresió') pw.Text(label, style: pw.TextStyle(fontSize: 8)),
      pw.Container(
          width: 50,
          height: 50,
          alignment: pw.Alignment.center,
          decoration: const pw.BoxDecoration(
              color: PdfColors.blue100, shape: pw.BoxShape.circle),
          child: _formatNumber(value)),
      if (label != 'Expresió') pw.Text(label, style: pw.TextStyle(fontSize: 8)),
    ]);
  }

  pw.Widget _buildLifePath(Map<String, int> values, String date) {
    return pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
            border: pw.Border.all(), borderRadius: pw.BorderRadius.circular(4)),
        child: pw.Stack(children: [
          // Connections
          pw.Positioned.fill(child: pw.CustomPaint(painter: (canvas, size) {
            double w = size.x;
            // Inverting Y coordinates
            double y1 = size.y - 45; // Top
            double y2 = size.y - 110; // Mid
            double y3 = size.y - 170; // Bot

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
            pw.Text('Camí de vida: $date',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(height: 10),
            // Top: Camino de Vida
            pw.Row(children: [
              pw.Spacer(),
              _buildPersonalitySquarePDF(
                  'Camí de Vida', values['Camino de Vida'] ?? 0),
              pw.Spacer(),
            ]),
            pw.SizedBox(height: 10),
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
            pw.SizedBox(height: 10),
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
        ]));
  }

  pw.Widget _buildSingleArc(Map<String, int> values, String topKey,
      String centerKey, String leftKey, String rightKey) {
    // Keys expected: 'Misión', 'Iniciacio', 'Evolutivo', 'Desarrollar'
    // Map usage:
    // Left (Mision): values['Misión']
    // Right (Iniciacio): values['Iniciacio']
    // Top (Apertura/Evolutivo?): Wait, mockup says "Apertura" at top. Code passed 'Evolutivo'.
    // Let's check calculateValues. 'Apertura' is also calculated.
    // The user mockup shows "Apertura" at the top.

    // Bottom (Desarrollar): values['Desarrollar']
    // Left Bottom (NL): values['NL']
    // Right Bottom (Expresión): values['Expresión'] - wait, user mockup has 3 bottom values?
    // Mockup:
    // Top: Apertura
    // Bottom Left: NL
    // Bottom Center: Desarrollar
    // Bottom Right: Expresión
    // Arcs connect NL and Expresión to the center line.

    // We need 'Apertura', 'NL', 'Desarrollar', 'Expresión'.
    // Let's ensure we have these keys.

    return pw.Container(
      height: 200,
      width: 250,
      child: pw.Stack(
        alignment: pw.Alignment.center,
        children: [
          // Custom Paint for Arrow and Arcs
          pw.Center(
            child: pw.CustomPaint(
              size: const PdfPoint(200, 150),
              painter: (PdfGraphics canvas, PdfPoint size) {
                double cx = size.x / 2;
                double top = size.y;
                double bottom = 0;

                // Main Vertical Arrow (Desarrollar -> Apertura)
                canvas.setColor(PdfColors.black);
                canvas.setLineWidth(2);
                canvas.drawLine(cx, bottom + 20, cx, top - 20);
                canvas.strokePath();

                // Arrow Head
                canvas.drawLine(cx, top - 20, cx - 5, top - 30);
                canvas.drawLine(cx, top - 20, cx + 5, top - 30);
                canvas.strokePath();

                // Arcs
                // Left Arc (NL -> Center Line)
                // Right Arc (Expresión -> Center Line)
                // We can approximate arcs with bezier curves or ellipses.
                // Draw Left Arc
                // Simple approach: Semi-circles using curveTo
                // Left Arc
                canvas.moveTo(cx - 60, bottom + 20);
                canvas.curveTo(
                    cx - 60, bottom + 80, cx, bottom + 80, cx, bottom + 60);
                canvas.strokePath();

                // Right Arc
                canvas.moveTo(cx + 60, bottom + 20);
                canvas.curveTo(
                    cx + 60, bottom + 80, cx, bottom + 80, cx, bottom + 60);
                canvas.strokePath();
              },
            ),
          ),

          // Labels
          // Top
          pw.Positioned(
            top: 0,
            child: _buildArcLabel(topKey, values[topKey] ?? 0),
          ),

          // Bottom Center
          pw.Positioned(
            bottom: 0,
            child: _buildArcLabel(centerKey, values[centerKey] ?? 0),
          ),

          // Bottom Left
          pw.Positioned(
            bottom: 0,
            left: 20,
            child: _buildArcLabel(leftKey, values[leftKey] ?? 0),
          ),

          // Bottom Right
          pw.Positioned(
            bottom: 0,
            right: 20,
            child: _buildArcLabel(rightKey, values[rightKey] ?? 0),
          ),
        ],
      ),
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

  pw.Widget _formatNumber(int value) {
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
          fontSize: 12,
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
        break;
      case SvgIdentifiers.CAP_ESQUERRE:
        baseId = "CapEsquerre";
        break;
      case SvgIdentifiers.BRAC_ESQUERRE:
        baseId = "BracEsquerre";
        break;
      case SvgIdentifiers.PANXA_ESQUERRE:
        baseId = "PanxaEsquerre";
        break;
      case SvgIdentifiers.CADERA:
        baseId = "Cadera";
        break;
      case SvgIdentifiers.CAMA_ESQUERRE:
        baseId = "CamaEsquerre";
        break;
      case SvgIdentifiers.CAMA_DRETA:
        baseId = "CamaDreta";
        break;
      case SvgIdentifiers.PANXA_DRETA:
        baseId = "PanxaDreta";
        break;
      case SvgIdentifiers.BRAC_DRET:
        baseId = "BracDret";
        break;
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
