import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:monitax/screens/weekly_kpi.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:monitax/screens/profile.dart';
import 'package:monitax/screens/login.dart';
import 'package:monitax/screens/custom_card.dart';
import 'package:monitax/screens/dailyinvoice_detail.dart';
import '../models/dailyinv.dart';
import '../services/invoice_api.dart';
import 'package:monitax/screens/invoice_summary.dart';

final fortmatCurrency = NumberFormat.simpleCurrency(locale: 'id-ID');

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<DailyInvoice?> futureData;

  @override
  void initState() {
    super.initState();
    futureData = DailyInvoiceApi().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            futureData = DailyInvoiceApi().fetchData();
          });
        },
        child: const Icon(Icons.refresh_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      appBar: AppBar(
        title: const Text('Monitax'),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Profile(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder<DailyInvoice?>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerCard(context);
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                showTopSnackBar(context,
                    const CustomSnackBar.error(message: 'Loading data failed'));
                return ShimmerCard(context);
              } else if (snapshot.hasData) {
                return MonitaxWidget(snapshot.data);
              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          }),
    );
  }
}

// ignore: non_constant_identifier_names
Widget ShimmerCard(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade500,
    highlightColor: Colors.white,
    child: GridView.count(
      padding: const EdgeInsets.all(4),
      crossAxisCount: 2,
      children: const <Widget>[Card(), Card(), Card(), Card(), Card()],
    ),
  );
}

class MonitaxWidget extends StatelessWidget {
  final DailyInvoice? data;
  const MonitaxWidget(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(4.0),
      crossAxisCount: 2,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DailyInvoiceListView(
                  data: data!.invoices,
                ),
              ),
              (route) => false,
            );
          },
          child: CustomCard(
              title: 'Today sales ',
              content: fortmatCurrency.format(data!.total),
              image: 'assets/images/earn.png',
              color: Colors.blue),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => InvoiceSummary(
                  data: data!.invoices,
                ),
              ),
              (route) => false,
            );
          },
          child: CustomCard(
            title: 'Today transaction ',
            content: data!.count.toString(),
            image: 'assets/images/orders.png',
            color: Colors.greenAccent,
          ),
        ),
        CustomCard(
            title: 'Pajak pendapatan ',
            content: fortmatCurrency.format(data!.tax),
            image: 'assets/images/taxes.png',
            color: Colors.purpleAccent),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const KpiPage()),
              (route) => false,
            );
          },
          child: CustomCard(
              title: 'Weekly KPI',
              content: "",
              image: 'assets/images/kpi.png',
              color: Colors.amberAccent),
        ),
        CustomCard(
            title: 'Notifikasi ',
            content: "test",
            image: 'assets/images/alert.png',
            color: Colors.amberAccent),
      ],
    );
  }
}
