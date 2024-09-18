import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import '../ui_widgets/life_cycles_widget.dart'; // Importa el widget de la taula

class LifeCyclesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataModel = Provider.of<DataModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Afegeix espai al voltant
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mostrem el nom i la data de manera elegant
            Text(
              dataModel.name, // Nom de l'usuari
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Text elegant i visible
              ),
            ),
            SizedBox(height: 8), // Espai entre el nom i la data
            Text(
              dataModel.date, // Data
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600], // Text més petit i subtil per a la data
              ),
            ),
            SizedBox(height: 10), // Espai entre el bloc de nom/data i la taula

            // Aquí afegim el MapTableWidget amb Expanded perquè ocupi tot l'espai disponible
            Expanded(
              child: MapTableWidget(
                dataMap: dataModel.habitants,
                vida: dataModel.reduceLife,
                date: dataModel.date,
              ), // Usa el mapa de cicles de vida
            ),
          ],
        ),
      ),
    );
  }
}
