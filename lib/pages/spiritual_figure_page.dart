import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import '../services/svg_dinamic_service.dart';

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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              dataModel.date,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20), // Espacio entre el texto y el Row
            // Mostrar el Row con los valores de yin, el SVG y yang
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mostrar el valor de yin
                Column(
                  children: [
                    Text(
                      'Yang: ${dataModel.yang}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(width: 20), // Espacio entre yin y el SVG
                // Mostrar el SVG
                SvgDynamicRenderer(
                  width: size.width * 0.3, // Ajusta el ancho según tus necesidades
                  height: size.height * 0.75, // Ajusta la altura según tus necesidades
                  svgName: svgName,
                  dia: dataModel.dia,
                  mes: dataModel.mes,
                  any: dataModel.any,
                  vida: dataModel.reduceLife,
                  mapFigura: dataModel.mapFigura,
                ),
                SizedBox(width: 20), // Espacio entre el SVG y yang
                // Mostrar el valor de yang
                Column(
                  children: [
                    Text(
                      'Yin: ${dataModel.yin}',
                      style: TextStyle(fontSize: 18),
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
