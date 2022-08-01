import 'package:flutter/material.dart';
import 'package:monitax/models/invoice.dart';
import 'package:monitax/config.dart';
import 'package:monitax/screens/home.dart';

class DailyInvoiceListView extends StatefulWidget {
  final List<Invoice?> data;
  const DailyInvoiceListView({Key? key, required this.data}) : super(key: key);

  @override
  State<DailyInvoiceListView> createState() => _DailyInvoiceListViewState();
}

class _DailyInvoiceListViewState extends State<DailyInvoiceListView> {
  List<Invoice?> _foundinvoices = [];
  @override
  void initState() {
    super.initState();
    _foundinvoices = widget.data;
  }

  void runfilter(String keyword) {
    List<Invoice?>? result = [];
    if (keyword.isEmpty || keyword.length == 0) {
      result = widget.data;
    } else {
      result = widget.data
          .where((element) => element!.invoice_num
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundinvoices = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Today sales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => runfilter(value),
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  hintText: 'Invoice number',
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: (_foundinvoices.isNotEmpty)
                    ? invoiceListView(_foundinvoices)
                    : const Text('No result found')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.home),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const HomePage(),
              ),
              (route) => false,
            );
          }),
    ));
  }

  ListView invoiceListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: tile(
                data[index].invoice_num,
                Config.formatDate
                    .format(DateTime.parse(data[index].invoice_date).toLocal()),
                fortmatCurrency.format(data[index].total_value),
                fortmatCurrency.format(data[index].tax_value),
                data[index].device_name,
                Icons.account_balance_outlined),
          );
        });
  }

  ListTile tile(String title, String subtitle, String total, String tax,
          String device_name, IconData icon) =>
      ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Text(
          'Date: $subtitle \nDevice: $device_name \nTotal: $total \nTax: $tax',
          style: const TextStyle(fontSize: 12),
        ),
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
      );
}
