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
    TextStyle smallTextStyle = TextStyle(fontSize: 11); // Mida de la font reduïda

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10, // Redueix l’espai entre columnes
        dataRowHeight: 40, // Ajusta l’alçada de les files
        columns: _buildColumns(smallTextStyle),
        rows: _buildRows(smallTextStyle),
      ),
    );
  }

  List<DataColumn> _buildColumns(TextStyle textStyle) {
    List<DataColumn> columns = [
      DataColumn(label: Text('', style: textStyle)), // Columna vacía per a títols
    ];

    int maxColumns = tableData.values.map((listOfLists) => listOfLists.length).reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxColumns; i++) {
      columns.add(DataColumn(label: Text('Casa ${i + 1}', style: textStyle)));
    }

    return columns;
  }

  List<DataRow> _buildRows(TextStyle textStyle) {
    return tableData.entries.map((entry) {
      String rowTitle = entry.key;
      List<List<int>> rowValues = entry.value;

      List<DataCell> cells = [
        DataCell(Text(rowTitle, style: textStyle.copyWith(fontWeight: FontWeight.bold)))
      ];

      cells.addAll(rowValues.map((valueList) {
        String cellContent = valueList.isEmpty
            ? '☀'
            : valueList.map((value) {
                if (rowTitle == 'Puentes') {
                  if (value == 0) {
                    return '-';
                  } else if (value > 9) {
                    int reducedValue = reduceToSingleDigit(value);
                    return '$value / $reducedValue';
                  } else {
                    return value.toString();
                  }
                } else {
                  if (value == 0) {
                    return '☀';
                  } else if (value > 9) {
                    int reducedValue = reduceToSingleDigit(value);
                    return '$value / $reducedValue';
                  } else {
                    return value.toString();
                  }
                }
              }).join(', ');

        return DataCell(
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Redueix el padding
            child: Text(cellContent, style: textStyle),
          ),
        );
      }).toList());

      return DataRow(cells: cells);
    }).toList();
  }
}
