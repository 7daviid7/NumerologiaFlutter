import 'package:flutter/material.dart';
import 'package:numerologia/ui_widgets/figura_widget.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';

class SpiritualFigurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);
    const String svgName = 'siluetaT';

    // Obtenemos el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar el nombre y la fecha
            Text(
              dataModel.name,
              style: TextStyle(
                fontSize: size.width * 0.016, // Ajuste del tamaño de fuente relativo al ancho de la pantalla
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              dataModel.date,
              style: TextStyle(
                fontSize: size.width * 0.015, // Ajuste del tamaño de fuente relativo
                color: Colors.grey,
              ),
            ),
            SizedBox(height: size.height * 0.05), // Espacio relativo al tamaño de la pantalla
            // Mostrar el Row con los valores de yin, el SVG y yang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mostrar el valor de yin
                Column(
                  children: [
                    Text(
                      'Yang: ${dataModel.yang}',
                      style: TextStyle(fontSize: size.width * 0.02),
                    ),
                  ],
                ),
                SizedBox(width: size.width * 0), // Espacio relativo
                // Mostrar el SVG
                FiguraWidget(
                  nameSVG: svgName, 
                  width: size.width * 0.35, 
                  height: size.height * 0.75
                ),
                SizedBox(width: size.width * 0), // Espacio relativo
                // Mostrar el valor de yang
                Column(
                  children: [
                    Text(
                      'Yin: ${dataModel.yin}',
                      style: TextStyle(fontSize: size.width * 0.02),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
