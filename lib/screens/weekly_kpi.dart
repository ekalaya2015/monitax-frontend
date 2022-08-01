import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitax/models/kpi.dart';
import 'package:monitax/screens/home.dart';
import 'package:monitax/services/weeklykpi_api.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class KpiPage extends StatefulWidget {
  const KpiPage({Key? key}) : super(key: key);

  @override
  State<KpiPage> createState() => _KpiPageState();
}

class _KpiPageState extends State<KpiPage> {
  late Future<List<KPI>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = KPIApi().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(),
            ),
            (route) => false,
          );
        },
        child: const Icon(Icons.home),
      ),
      appBar: AppBar(
        title: const Text('Weekly KPI'),
      ),
      body: FutureBuilder<List<KPI>>(
          future: futureData,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ShimmerChart(context);
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                showTopSnackBar(context,
                    const CustomSnackBar.error(message: 'Loading data failed'));
                return ShimmerChart(context);
              } else if (snapshot.hasData) {
                return KPIChart(data: snapshot.data!);
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

class KPIChart extends StatelessWidget {
  final List<KPI> data;
  const KPIChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(crossAxisCount: 1, children: [
        //Initialize the chart widget
        Card(
          elevation: 4,
          child: SfCartesianChart(
              plotAreaBackgroundColor: Colors.amber[50],
              primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Tanggal')),
              primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compactCurrency(
                      locale: 'id-ID', symbol: 'Rp')),
              // Chart title
              title: ChartTitle(text: 'Weekly sales'),
              // Enable legend
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <SplineAreaSeries<KPI, String>>[
                SplineAreaSeries<KPI, String>(
                    dataSource: data,
                    xValueMapper: (KPI sales, _) {
                      List<String> list = sales.date.split('-');
                      String label = '${list[1]}/${list[2]}';
                      return label;
                    },
                    yValueMapper: (KPI sales, _) => sales.total,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false)),
                SplineAreaSeries<KPI, String>(
                    emptyPointSettings:
                        EmptyPointSettings(mode: EmptyPointMode.gap),
                    dataSource: data,
                    xValueMapper: (KPI sales, _) {
                      List<String> list = sales.date.split('-');
                      String label = '${list[1]}/${list[2]}';
                      return label;
                    },
                    yValueMapper: (KPI sales, _) => sales.tax,
                    name: 'Tax',
                    // Enable data label
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false))
              ]),
        ),
        Card(
            elevation: 4,
            child: SfCartesianChart(
                title: ChartTitle(text: 'Weekly Transaction'),
                plotAreaBackgroundColor: Colors.amber[50],
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Tanggal')),
                legend:
                    Legend(isVisible: true, position: LegendPosition.bottom),
                series: <BarSeries<KPI, String>>[
                  BarSeries(
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      name: 'Transaction',
                      dataSource: data,
                      xValueMapper: (KPI _kpi, _) => _kpi.date,
                      yValueMapper: (KPI _kpi, _) => _kpi.trx)
                ]))
      ]),
    );
  }
}

// ignore: non_constant_identifier_names
Widget ShimmerChart(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade500,
      highlightColor: Color.fromARGB(255, 255, 255, 255),
      child: GridView.count(
        padding: const EdgeInsets.all(4),
        crossAxisCount: 1,
        children: const <Widget>[Card(), Card()],
      ));
}
