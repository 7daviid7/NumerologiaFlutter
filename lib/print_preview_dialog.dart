// print_preview_dialog.dart

import 'package:flutter/material.dart';
import 'print_service.dart'; // Assegura't que el servei d'impressió es troba en el mateix directori

class PrintPreviewDialog {
  final PrintService _printService = PrintService();

  Future<void> showPreviewAndPrint(
      BuildContext context, GlobalKey globalKey, String title) async {
    // Captura la imatge del widget
    final imageBytes = await _printService.captureWidgetAsImage(globalKey);

    // Comprova si el context encara està muntat abans de mostrar el diàleg
    if (!context.mounted) return;

    // Mostra la vista prèvia en un diàleg
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(imageBytes), // Mostra la imatge capturada
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(), // Cancel·la la impressió
                    child: Text('Cancel·lar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Tanca el diàleg
                      await _printService.printImage(imageBytes, title); // Imprimeix la imatge
                    },
                    child: Text('Imprimir'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
