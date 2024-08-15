import 'package:euro_scanner/models/dbModels/projects.dart';
import 'package:flutter/material.dart';

class LogsRowSource extends DataTableSource {
  var myData;
  final count;
  LogsRowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else {
      return null;
    }
  }

  void sort<T>(Comparable<T> Function(Logs d) getField, bool ascending) {
    myData.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(Logs data) {
  return DataRow(
    cells: [
      DataCell(SizedBox(child: Text(data.id.toString()))),
      DataCell(Text(data.qrCode.toString())),
      DataCell(Text(data.scanDateTime.toString())),
      DataCell(Text(data.status.toString())),
      DataCell(Text(data.remarks.toString())),
      DataCell(Text(data.scanBy.toString())),
      DataCell(Text(data.scanFor.toString())),
      // DataCell(Text(data.lastScanDate.toString().split(".")[0])),
    ],
  );
}