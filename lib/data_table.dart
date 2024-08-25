import 'package:flutter/material.dart';

// Funció per reduir un valor a un sol dígit
int reduceToSingleDigit(int number) {
  while (number > 9) {
    number = number.toString().split('').map(int.parse).reduce((a, b) => a + b);
  }
  return number;
}

class DataTableWidget extends StatelessWidget {
  final Map<String, List<List<int>>> tableData;

  DataTableWidget({required this.tableData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: _buildColumns(),
        rows: _buildRows(),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    // La primera columna es para los títulos de las filas
    List<DataColumn> columns = [
      DataColumn(label: Text('')), // Columna vacía para los títulos de las filas
    ];

    // Determinamos el número máximo de columnas necesarias
    int maxColumns = tableData.values.map((listOfLists) => listOfLists.length).reduce((a, b) => a > b ? a : b);

    // Creamos las columnas con los títulos "Casa 1", "Casa 2", etc.
    for (int i = 0; i < maxColumns; i++) {
      columns.add(DataColumn(label: Text('Casa ${i + 1}')));
    }

    return columns;
  }

  List<DataRow> _buildRows() {
    // Generamos las filas de la tabla basándonos en las claves del mapa
    return tableData.entries.map((entry) {
      String rowTitle = entry.key; // Título de la fila (clave del mapa)
      List<List<int>> rowValues = entry.value;

      // Creamos la primera celda con el título de la fila
      List<DataCell> cells = [DataCell(Text(rowTitle, style: TextStyle(fontWeight: FontWeight.bold)))];

      // Creamos las celdas para cada valor en las columnas
      cells.addAll(rowValues.map((valueList) {
        // Generamos el texto para cada valor
        String cellContent = valueList.isEmpty
            ? '☀' // Si no hay valor, mostramos el símbolo del sol
            : valueList.map((value) {
                if (rowTitle == 'Puentes') {
                  // Para la fila 'Puentes', mostramos '-' si el valor es cero
                  if (value == 0) {
                    return '-';
                  } else if (value > 9) {
                    // Reducimos el valor si es mayor que 9
                    int reducedValue = reduceToSingleDigit(value);
                    return '$value / $reducedValue'; // Mostramos el valor original y el reducido con un separador
                  } else {
                    return value.toString(); // Si no es mayor que 9, mostramos el valor original
                  }
                } else {
                  // Para otras filas, mostramos el símbolo del sol para el valor 0
                  if (value == 0) {
                    return '☀';
                  } else if (value > 9) {
                    // Reducimos el valor si es mayor que 9
                    int reducedValue = reduceToSingleDigit(value);
                    return '$value / $reducedValue'; // Mostramos el valor original y el reducido con un separador
                  } else {
                    return value.toString(); // Si no es mayor que 9, mostramos el valor original
                  }
                }
              }).join(', '); // Unimos los valores con coma

        return DataCell(Text(cellContent));
      }).toList());

      return DataRow(cells: cells);
    }).toList();
  }
}
