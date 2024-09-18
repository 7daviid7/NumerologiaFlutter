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
        child: SvgDynamicRenderer(
          width: size.width, // Usamos el ancho de la pantalla disponible
          height: size.height, // Usamos el alto de la pantalla disponible
          svgName: svgName,
          dia: dataModel.reduceDia, 
          mes: dataModel.reduceMes, 
          any: dataModel.reduceAny, 
          vida: dataModel.reduceLife,
          mapFigura: dataModel.mapFigura,
        ),
      ),
    );
  }
}
