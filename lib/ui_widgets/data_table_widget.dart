import 'package:flutter/material.dart';
import '../services/numerology_calculation_service.dart';

class DataTableWidget extends StatefulWidget {
  final Map<String, List<List<int>>> tableData;

  DataTableWidget({required this.tableData});

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double availableHeight = constraints.maxHeight;

        // Càlcul de la mida ideal basada en l'amplada
        double widthBasedFontSize = availableWidth / 25;

        // Càlcul de la mida ideal basada en l'alçada (si és finita)
        double heightBasedFontSize = double.infinity;
        if (availableHeight != double.infinity) {
          heightBasedFontSize = availableHeight / 20;
        }

        // Triem la mida més restrictiva
        double optimalFontSize = widthBasedFontSize < heightBasedFontSize
            ? widthBasedFontSize
            : heightBasedFontSize;

        // Apliquem límits:
        double fontSize = optimalFontSize;
        if (fontSize < 14.0) {
          fontSize = 14.0; // Mínim augmentat per llegibilitat
        }
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

        // Estructura per a scroll bidireccional amb barres interactives:
        // Necessitem dos Scrollbars i dos SingleChildScrollViews niats.
        return Scrollbar(
          controller: _verticalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            child: Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _horizontalController,
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

    int maxColumns = widget.tableData.values
        .map((listOfLists) => listOfLists.length)
        .reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < maxColumns; i++) {
      columns.add(DataColumn(label: Text('Casa ${i + 1}', style: textStyle)));
    }

    return columns;
  }

  List<DataRow> _buildRows(TextStyle textStyle, TextStyle darkNumberTextStyle,
      TextStyle sunSymbolStyle) {
    return widget.tableData.entries.map((entry) {
      String rowTitle = entry.key;
      List<List<int>> rowValues = entry.value;

      List<DataCell> cells = [DataCell(Text(rowTitle, style: textStyle))];

      cells.addAll(rowValues.map((valueList) {
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
              vertical: textStyle.fontSize! * 0.6,
              horizontal: textStyle.fontSize! * 0.5,
            ),
            alignment: Alignment.center,
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
