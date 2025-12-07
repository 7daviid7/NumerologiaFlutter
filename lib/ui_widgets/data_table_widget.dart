import 'package:flutter/material.dart';
import '../services/numerology_calculation_service.dart';

class DataTableWidget extends StatelessWidget {
  final Map<String, List<List<int>>> tableData;

  DataTableWidget({required this.tableData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;

        // Ajustem la mida del text segons l'amplada disponible
        // Utilitzem un mínim de 10.0 per assegurar llegibilitat (scroll si és necessari)
        double availableHeight = constraints.maxHeight;

        // Càlcul de la mida ideal basada en l'amplada
        double widthBasedFontSize = availableWidth / 25;

        // Càlcul de la mida ideal basada en l'alçada (si és finita)
        // Assumim ~22 files de dades (incloent capçaleres i marges)
        double heightBasedFontSize = double.infinity;
        if (availableHeight != double.infinity) {
          heightBasedFontSize = availableHeight / 20;
        }

        // Triem la mida més restrictiva per evitar overflow (intentar que tot càpiga)
        double optimalFontSize = widthBasedFontSize < heightBasedFontSize
            ? widthBasedFontSize
            : heightBasedFontSize;

        // Apliquem límits:
        // Mínim 10.0: Per sota d'això és il·legible -> Activem scroll.
        // Màxim 18.0: Per sobre d'això és massa gran -> Deixem espai buit.
        double fontSize = optimalFontSize;
        if (fontSize < 10.0) fontSize = 10.0;
        if (fontSize > 18.0) fontSize = 18.0;

        double titleFontSize = fontSize * 0.7;

        // Creem l'estil del text
        TextStyle smallTextStyle =
            TextStyle(fontSize: fontSize * 0.6, fontWeight: FontWeight.bold);
        TextStyle titleTextStyle =
            TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold);
        TextStyle darkNumberTextStyle =
            TextStyle(fontSize: fontSize, color: Colors.black87);
        TextStyle sunSymbolStyle = TextStyle(fontSize: fontSize * 0.5);

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: availableWidth),
              child: DataTable(
                columnSpacing: fontSize * 0.5, // Espaiat basat en la font
                horizontalMargin: fontSize * 0.5,
                dataRowMinHeight: fontSize * 1.5,
                dataRowMaxHeight: fontSize * 2.5,
                columns: _buildColumns(titleTextStyle),
                rows: _buildRows(
                    smallTextStyle, darkNumberTextStyle, sunSymbolStyle),
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

    int maxColumns = tableData.values
        .map((listOfLists) => listOfLists.length)
        .reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxColumns; i++) {
      columns.add(DataColumn(label: Text('Casa ${i + 1}', style: textStyle)));
    }

    return columns;
  }

  List<DataRow> _buildRows(TextStyle textStyle, TextStyle darkNumberTextStyle,
      TextStyle sunSymbolStyle) {
    return tableData.entries.map((entry) {
      String rowTitle = entry.key;
      List<List<int>> rowValues = entry.value;

      List<DataCell> cells = [DataCell(Text(rowTitle, style: textStyle))];

      cells.addAll(rowValues.map((valueList) {
        // Combinem els valors en un string amb el símbol del sol ajustat
        String cellContent = valueList.isEmpty
            ? '☀'
            : valueList.map((value) {
                if (rowTitle == 'Puentes') {
                  if (value == 0) {
                    return '-';
                  } else if (value > 9) {
                    int reducedValue = reduceToSingleDigitResult(value);
                    return '$value / $reducedValue';
                  } else {
                    return value.toString();
                  }
                } else {
                  if (value == 0) {
                    return '☀';
                  } else if (value > 9) {
                    int reducedValue = reduceToSingleDigitResult(value);
                    return '$value / $reducedValue';
                  } else {
                    return value.toString();
                  }
                }
              }).join(', ');

        return DataCell(
          Container(
            padding: EdgeInsets.symmetric(
              vertical:
                  textStyle.fontSize! * 0.6, // Ajustament dinàmic del padding
              horizontal:
                  textStyle.fontSize! * 0.5, // Ajustament dinàmic del padding
            ),
            alignment: Alignment.center, // Centrar el contingut
            child: Align(
              alignment: Alignment.center,
              child: Text(
                cellContent,
                style: darkNumberTextStyle.copyWith(
                  fontSize: (cellContent.contains('☀')
                      ? sunSymbolStyle.fontSize
                      : darkNumberTextStyle.fontSize),
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
