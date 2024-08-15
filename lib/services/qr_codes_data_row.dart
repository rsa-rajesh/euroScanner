import 'package:euro_scanner/models/dbModels/projects.dart';
import 'package:flutter/material.dart';

class QrCodesRowSource extends DataTableSource {
  var myData;
  final count;
  QrCodesRowSource({
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

  void sort<T>(Comparable<T> Function(QrCodes d) getField, bool ascending) {
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

DataRow recentFileDataRow(QrCodes data) {
  return DataRow(
    cells: [
      DataCell(SizedBox(child: Text(data.id.toString()))),
      DataCell(Text(data.qrCode.toString())),
      DataCell(Text(data.status.toString())),
      DataCell(Text(data.dispatchedCount.toString())),
      DataCell(Text(data.scanCount.toString())),
      DataCell(Text(data.totalCash.toString())),
      DataCell(Text(data.totalPoints.toString())),
      DataCell(Text(data.lastScanDate.toString().split(".")[0])),
    ],
  );
}