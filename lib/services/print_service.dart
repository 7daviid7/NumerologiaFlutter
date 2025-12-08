import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';

class PrintService {
  Future<Uint8List> captureWidgetAsImage(GlobalKey key) async {
    // Check if the context is valid before finding the render object
    if (key.currentContext == null) {
      throw Exception("Context is null. Cannot capture widget.");
    }

    RenderRepaintBoundary? boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception(
          "RenderRepaintBoundary not found. Widget might not be painted yet.");
    }

    // Capture the image
    // You can adjust pixelRatio for better quality/performance trade-off.
    // 2.0 is usually good for printing (approx 192dpi equivalent on screen).
    // If it crashes due to memory, try lowering to 1.5 or 1.0.
    var image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Failed to convert image to byte data.");
    }

    return byteData.buffer.asUint8List();
  }

  Future<void> printImage(Uint8List imageBytes, String title) async {
    final pdf = pw.Document();

    // Use A4 landscape format
    final pageFormat = PdfPageFormat.a4.landscape.copyWith(
      marginLeft: 0,
      marginTop: 40,
      marginRight: 0,
      marginBottom: 40,
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
              fit: pw.BoxFit.fill, // Adjust image fit
            ),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();

    // Directly trigger the print/preview dialog with the PDF bytes.
    // This works on Web, Windows, macOS, Android, and iOS.
    // It avoids 'path_provider' and 'dart:io' file system limitations on Web.
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: '$title.pdf', // Optional: suggestions filename for saving
    );
  }
}
