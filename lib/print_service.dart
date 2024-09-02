import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PrintService {
  Future<Uint8List> captureWidgetAsImage(GlobalKey key) async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 2.0); // Ajusta el pixelRatio segons calgui
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> printImage(Uint8List imageBytes, String title) async {
    final pdf = pw.Document();
    // Definir el format de pàgina A4 en horitzontal
    final pageFormat = PdfPageFormat.a4.landscape.copyWith(
    marginLeft: 0.2,
    marginTop: 0,
    marginRight: 0,
    marginBottom: 0,
  );


    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Container(
            width: pageFormat.width,
            height: pageFormat.height,
            child: pw.Image(
              pw.MemoryImage(imageBytes),
              fit: pw.BoxFit.fill, // Ajusta la imatge sense tallar-la
            ),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();

    // Obtenir el directori on desar el fitxer
    final outputDir = await getApplicationDocumentsDirectory();
    final outputFile = File('${outputDir.path}/output.pdf');

    // Desa el PDF en un fitxer local
    await outputFile.writeAsBytes(pdfBytes);

    // Imprimir el PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
  }
}
