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
    double fontsize = size.width < 400 ? 15 : 24;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar el nombre y la fecha
            Text(
              dataModel.name,
              style: TextStyle(
                fontSize: fontsize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              dataModel.date,
              style: TextStyle(
                fontSize: fontsize,
                color: Colors.grey,
              ),
            ),
            SizedBox(
                height: size.height *
                    0.05), // Espacio relativo al tamaño de la pantalla
            // Mostrar el Row con los valores de yin, el SVG y yang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mostrar el valor de yin
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Text(
                        'Yang: ${dataModel.yang}',
                        style: TextStyle(
                            fontSize: size.width * 0.02 < 14.0
                                ? 14.0
                                : size.width * 0.02),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width * 0.02), // Espacio relativo
                // Mostrar el SVG
                Flexible(
                  // Flexible amb loose fit permet que les columnes s'acostin
                  fit: FlexFit.loose,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculem dimensions basades en l'espai disponible (com un gas)
                      double availableWidth = constraints.maxWidth;
                      // Usem una alçada màxima de referència (per exemple 75% de la pantalla)
                      double maxHeightConstraint =
                          MediaQuery.of(context).size.height * 0.75;

                      double targetAspectRatio = 1.0 / 1.15; // aprox 0.87 ratio

                      // Calculem l'alçada si usem tota l'amplada
                      double heightBasedOnWidth =
                          availableWidth / targetAspectRatio;

                      double finalWidth;
                      double finalHeight;

                      if (heightBasedOnWidth > maxHeightConstraint) {
                        // Si l'alçada supera el màxim, limitem l'alçada i recalculem l'amplada
                        finalHeight = maxHeightConstraint;
                        finalWidth = finalHeight * targetAspectRatio;
                      } else {
                        // Si cap bé, usem l'amplada disponible
                        finalWidth = availableWidth;
                        finalHeight = heightBasedOnWidth;
                      }

                      return SizedBox(
                        // Envolcallem en container per donar mida concreta
                        width: finalWidth,
                        height: finalHeight,
                        child: FiguraWidget(
                          nameSVG: svgName,
                          width: finalWidth,
                          height: finalHeight,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: size.width * 0.02), // Espacio relativo
                // Mostrar el valor de yang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Text(
                        'Yin: ${dataModel.yin}',
                        style: TextStyle(
                            fontSize: size.width * 0.02 < 14.0
                                ? 14.0
                                : size.width * 0.02),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
