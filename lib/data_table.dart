import 'package:flutter/material.dart';

class DataTableWidget extends StatelessWidget {
  final Map<String, List<String>> tableData;

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
    List<String> columnTitles = tableData.keys.toList();
    return columnTitles.map((title) {
      return DataColumn(label: Text(title));
    }).toList();
  }

  List<DataRow> _buildRows() {
    int rowCount = tableData.values.first.length;
    return List.generate(rowCount, (index) {
      List<DataCell> cells = tableData.values.map((list) {
        return DataCell(Text(list[index]));
      }).toList();
      return DataRow(cells: cells);
    });
  }
}
