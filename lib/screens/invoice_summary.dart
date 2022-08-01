import 'package:flutter/material.dart';
import 'package:monitax/models/invoice.dart';
import 'package:monitax/datasources/invoice_datasource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:monitax/screens/home.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class InvoiceSummary extends StatefulWidget {
  final List<Invoice> data;
  InvoiceSummary({Key? key, required this.data}) : super(key: key);

  @override
  State<InvoiceSummary> createState() => _InvoiceSummaryState();
}

class _InvoiceSummaryState extends State<InvoiceSummary> {
  late InvoiceDataSource invoiceDataSource;

  @override
  void initState() {
    super.initState();
    List<Invoice> invoices = widget.data;
    invoiceDataSource = InvoiceDataSource(invoices: invoices);
  }

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Summary'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: const Icon(Icons.home),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomePage(),
                  ),
                  (route) => false,
                );
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(headerColor: Colors.green[200]),
          child: SfDataGrid(
            // columnSizer: _customColumnSizer,
            // onQueryRowHeight: (details) {
            //   return details.getIntrinsicRowHeight(details.rowIndex);
            // },
            rowHeight: 32,
            source: invoiceDataSource,
            allowSorting: true,
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            tableSummaryRows: [
              GridTableSummaryRow(
                  showSummaryInRow: true,
                  title: 'Total sales (today): {SalesSum}',
                  color: Colors.amber[50],
                  columns: [
                    const GridSummaryColumn(
                        name: 'SalesSum',
                        columnName: 'sales',
                        summaryType: GridSummaryType.sum),
                  ],
                  position: GridTableSummaryRowPosition.bottom),
              GridTableSummaryRow(
                  color: Colors.amber[50],
                  title: 'Total Transaction: {Trx}',
                  columns: [
                    const GridSummaryColumn(
                        name: 'Trx',
                        columnName: 'id',
                        summaryType: GridSummaryType.count),
                  ],
                  position: GridTableSummaryRowPosition.top),
              GridTableSummaryRow(
                  color: Colors.amber[50],
                  title: 'Average Sales: {AvgSales}',
                  columns: [
                    const GridSummaryColumn(
                        name: 'AvgSales',
                        columnName: 'sales',
                        summaryType: GridSummaryType.average),
                  ],
                  position: GridTableSummaryRowPosition.bottom),
              GridTableSummaryRow(
                  color: Colors.amber[50],
                  title: 'Maximum Sales: {MaxSales}',
                  columns: [
                    const GridSummaryColumn(
                        name: 'MaxSales',
                        columnName: 'sales',
                        summaryType: GridSummaryType.maximum),
                  ],
                  position: GridTableSummaryRowPosition.bottom),
              GridTableSummaryRow(
                  color: Colors.amber[50],
                  title: 'Minimum Sales: {MinSales}',
                  columns: [
                    const GridSummaryColumn(
                        name: 'MinSales',
                        columnName: 'sales',
                        summaryType: GridSummaryType.minimum),
                  ],
                  position: GridTableSummaryRowPosition.bottom),
            ],
            columns: <GridColumn>[
              GridColumn(
                  columnName: 'id',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Inv Id'))),
              GridColumn(
                  columnName: 'date',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Date'))),
              GridColumn(
                  columnName: 'sales',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('Sales'))),
              GridColumn(
                  columnName: 'tax',
                  label: Container(
                      padding: const EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: const Text('Tax'))),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellHeight(GridColumn column, TextStyle textStyle) {
    if (column.columnName == 'id' || column.columnName == 'date') {
      textStyle = const TextStyle(
          fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);
    }
    return super.computeHeaderCellHeight(column, textStyle);
  }

  @override
  double computeCellHeight(GridColumn column, DataGridRow row,
      Object? cellValue, TextStyle textStyle) {
    if (column.columnName == 'id' || column.columnName == 'sales') {
      textStyle = const TextStyle(
          fontWeight: FontWeight.bold, fontStyle: FontStyle.italic);
    }
    return super.computeCellHeight(column, row, cellValue, textStyle);
  }
}
