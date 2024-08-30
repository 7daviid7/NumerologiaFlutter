import 'package:flutter/material.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Ajustem la mida del text segons l'amplada disponible
        double fontSize = availableWidth / 52;

        // Creem l'estil del text
        TextStyle smallTextStyle = TextStyle(fontSize: fontSize);

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: availableWidth),
            child: Container(
              width: availableWidth,
              child: DataTable(
                columnSpacing: availableWidth / 200, // Espai entre columnes proporcional
                dataRowMinHeight: availableHeight / 20, // Alçada de les files proporcional
                columns: _buildColumns(smallTextStyle),
                rows: _buildRows(smallTextStyle),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns(TextStyle textStyle) {
    List<DataColumn> columns = [
      DataColumn(label: Text('', style: textStyle)),
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
            padding: EdgeInsets.symmetric(
              vertical: textStyle.fontSize! * 0.6, // Ajustament dinàmic del padding
              horizontal: textStyle.fontSize! * 0.5, // Ajustament dinàmic del padding
            ),
            child: Text(cellContent, style: textStyle),
          ),
        );
      }).toList());

      return DataRow(cells: cells);
    }).toList();
  }
}
