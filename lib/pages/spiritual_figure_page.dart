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
            SizedBox(height: 50), // Espacio entre el texto y el SVG
            // Mostrar el SVG
            SvgDynamicRenderer(
              width: size.width, // Usamos el ancho de la pantalla disponible
              height: size.height * 0.7, // Usamos el 70% del alto de la pantalla disponible
              svgName: svgName,
              dia: dataModel.reduceDia,
              mes: dataModel.reduceMes,
              any: dataModel.reduceAny,
              vida: dataModel.reduceLife,
              mapFigura: dataModel.mapFigura,
            ),
          ],
        ),
      ),
    );
  }
}
