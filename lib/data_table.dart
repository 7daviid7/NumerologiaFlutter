import 'package:flutter/material.dart';
import 'numerology_calculation.dart';

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
        double fontSize = (availableWidth / 38);
        double titleFontSize = fontSize * 0.7; // Font més petit per als títols

        // Creem l'estil del text
        TextStyle smallTextStyle = TextStyle(fontSize: fontSize * 0.6, fontWeight: FontWeight.bold);
        TextStyle titleTextStyle = TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold);
        TextStyle darkNumberTextStyle = TextStyle(fontSize: fontSize, color: Colors.black87); // Color més fosc per als números
        TextStyle sunSymbolStyle = TextStyle(fontSize: fontSize * 0.5); // Mida més petita per al símbol del sol

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: availableWidth),
            child: Container(
              width: availableWidth,
              child: DataTable(
                columnSpacing: availableWidth / 200, // Espai entre columnes proporcional
                dataRowMinHeight: availableHeight / 20, // Alçada de les files proporcional
                columns: _buildColumns(titleTextStyle),
                rows: _buildRows(smallTextStyle, darkNumberTextStyle, sunSymbolStyle),
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

  List<DataRow> _buildRows(TextStyle textStyle, TextStyle darkNumberTextStyle, TextStyle sunSymbolStyle) {
    return tableData.entries.map((entry) {
      String rowTitle = entry.key;
      List<List<int>> rowValues = entry.value;

      List<DataCell> cells = [
        DataCell(Text(rowTitle, style: textStyle))
      ];

      cells.addAll(rowValues.map((valueList) {
        // Combinem els valors en un string amb el símbol del sol ajustat
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
            alignment: Alignment.center, // Centrar el contingut
            child: Align(
              alignment: Alignment.center,
              child: Text(
                cellContent,
                style: darkNumberTextStyle.copyWith(
                  fontSize: (cellContent.contains('☀') ? sunSymbolStyle.fontSize : darkNumberTextStyle.fontSize),
                ),
              ),
            ),
          ),
        );
      }).toList());

      return DataRow(cells: cells);
    }).toList();
  }
}
