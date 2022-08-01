import 'package:flutter/material.dart';
import 'package:monitax/models/invoice.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:monitax/config.dart';

class InvoiceDataSource extends DataGridSource {
  InvoiceDataSource({required List<Invoice> invoices}) {
    _invoices = invoices
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: e.invoice_num),
              DataGridCell<String>(
                  columnName: 'date',
                  value: Config.formatDate
                      .format(DateTime.parse(e.invoice_date).toLocal())),
              DataGridCell<double>(columnName: 'sales', value: e.total_value),
              DataGridCell<double>(columnName: 'tax', value: e.tax_value),
            ]))
        .toList();
  }
  List<DataGridRow> _invoices = [];

  @override
  List<DataGridRow> get rows => _invoices;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        color: (effectiveRows.indexOf(row) % 2 == 0)
            ? Colors.blue[50]
            : Colors.red[50],
        alignment: Alignment.center,
        padding: const EdgeInsets.all(2.0),
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 12),
        ),
      );
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    for (final element in summaryRow.columns) {
      if (element.name == 'SalesSum' ||
          element.name == 'AvgSales' ||
          element.name == 'MaxSales' ||
          element.name == 'MinSales') {
        // debugPrint(summaryValue);
        String _text = summaryValue.split(':')[0];
        String _val = summaryValue.split(':')[1];
        if (_val == " ") _val = '0';
        summaryValue =
            '$_text: ${Config.formatCurrency.format(double.parse(_val))}';
      }
    }
    return Container(
        alignment: Alignment.centerRight,
        child: Text(summaryValue, style: TextStyle(fontSize: 10)));
  }

  @override
  bool shouldRecalculateColumnWidths() {
    return true;
  }
}
