import 'package:flutter/material.dart';

class MapTableWidget extends StatelessWidget {
  final Map<int, int> dataMap;
  final int vida;
  final String date;
  final int any;

  // Constructor per rebre el mapa
  MapTableWidget(
      {required this.dataMap,
      required this.vida,
      required this.date})
      : any = int.parse(date.split('-')[0]);

  @override
  Widget build(BuildContext context) {
    // Llistes de claus i valors originals
    List<int> originalKeys = dataMap.keys.toList();
    List<int> originalValues = dataMap.values.toList();
    bool highlightFirstCel = false; 
    bool exception = false; 

    // Troba l'índex de la clau associada amb 'vida'
    int vidaIndex = originalKeys.indexOf(vida);

    // Reordenar les claus i els valors
    List<int> reorderedKeys = [
      ...originalKeys.sublist(vidaIndex, originalKeys.length-1), // Claus des de 'vida' fins al final
      ...originalKeys.sublist(0, vidaIndex) // Claus des de l'inici fins abans de 'vida'
    ];

    List<int> reorderedValues = [
      ...originalValues.sublist(vidaIndex, originalValues.length-1), // Valors des de 'vida' fins al final
      ...originalValues.sublist(0, vidaIndex) // Valors des de l'inici fins abans de 'vida'
    ];

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Taula centrada dins d'una pàgina amb espai disponible
            SizedBox(
              width: double.infinity, // Ocupa tot l'ample de la pàgina
              child: DataTable(
                columns: [
                  DataColumn(label: SizedBox.shrink()), // Primera columna buida
                  ...List.generate(originalKeys.length + 1, (index) => DataColumn(label: SizedBox.shrink())),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Cicles                       ')),
                      DataCell(SizedBox.shrink()), // Primera cel·la amb títol "Cicles"
                      ...originalKeys.map((key) => DataCell(
                        Text(
                          key == 0 ? '\u2600' : key.toString(), // Mostra el símbol del sol si el valor és 0
                          style: TextStyle(
                            fontSize: 18, // Ajusta la mida del text
                            fontWeight: FontWeight.bold, // Fes el text en negreta
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Habitants                    ')),
                      DataCell(SizedBox.shrink()), // Primera cel·la amb títol "Habitants"
                      ...originalValues.map((value) => DataCell(
                        Text(
                          value == 0 ? '\u2600' : value.toString(), // Mostra el símbol del sol si el valor és 0
                        ),
                      )).toList(), // Valors
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity, // Ocupa tot l'ample de la pàgina
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Habitants')),
                  DataColumn(label: Text('Anys Personals')),
                  ...List.generate(originalKeys.length, (index) => DataColumn(label: SizedBox.shrink())),
                ],
                rows: List.generate(
                  reorderedKeys.length, // Nombre de files
                  (filaIndex) {
                    int titolAnterior = filaIndex;
                    int anyAnterior = filaIndex + any;
                    int anyActual = 0;
                    int titolActual = 0;
                    // Valor que volem posar en la primera cel·la de la fila (reordenat segons el que vulguis)
                    int habitantValue = reorderedValues[filaIndex];
                    // Valor de la segona columna serà la "key" associada a l'habitant
                    int anyPersonal = reorderedKeys[filaIndex];

                    // Determina el color de fons segons el valor de 'anyPersonal'
                    Color rowColor = anyPersonal == 1 ? Colors.grey.withOpacity(0.2) : Colors.transparent;

                    return DataRow(
                      color: WidgetStateProperty.all(rowColor),
                      cells: [
                        DataCell(
                          Text(
                            habitantValue == 0 ? '\u2600' : habitantValue.toString(), // Mostra el símbol del sol si el valor és 0
                          ),
                        ), // Habitants
                        DataCell(
                          Text(
                            anyPersonal == 0 ? '\u2600' : anyPersonal.toString(), // Mostra el símbol del sol si el valor és 0
                          ),
                        ), // Anys Personals
                        ...List.generate(originalKeys.length, (colIndex) {
                          titolActual = titolAnterior;
                          anyActual = anyAnterior;
                          titolAnterior += 9;
                          anyAnterior += 9;

                          bool highlight = false;
                          int vidaResults = 0; 
                          // Calcular l'índex diagonal
                          if (exception) {
                            vidaResults = vida; 
                          } else {
                            vidaResults = vida - 1; 
                          }
                          int diagonalIndex = (vidaResults + filaIndex) % originalKeys.length;

                          // Marcar les cel·les en diagonal
                          if (colIndex == diagonalIndex) {
                            highlight = true;
                          }

                          if (colIndex == 0 && highlightFirstCel) {
                            highlight = true;
                            highlightFirstCel = false; 
                          }
                          if (colIndex == originalKeys.length - 1 && colIndex == diagonalIndex) {
                            exception = true; 
                          }
                          // Si estem a l'última cel·la de la fila i aquesta cel·la està en diagonal, marcar també la primera cel·la de la mateixa fila
                          if (colIndex == originalKeys.length - 2 && colIndex == diagonalIndex) {
                            // Marca la primera cel·la de la fila actual (columna 0) a part
                            highlightFirstCel = true; 
                          }

                          return DataCell(
                            Container(
                              color: highlight ? Colors.redAccent.withOpacity(0.3) : Colors.transparent, // Fons vermell suau
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    titolActual.toString(),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ), // Títol numèric
                                  Text(
                                    anyActual.toString(),
                                    style: TextStyle(fontSize: 14),
                                  ), // Any calculat
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
