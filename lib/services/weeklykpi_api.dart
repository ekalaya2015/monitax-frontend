import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:monitax/models/kpi.dart';
import 'package:monitax/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KPIApi {
  Future<List<KPI>> fetchData() async {
    var dio = Dio();
    Response response;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      response = await dio.get('${Config.apiURL}/invoices/weekly_stats',
          options: Options(contentType: Headers.jsonContentType, headers: {
            'Accept': 'application/json',
            'Access-Control_Allow_Origin': '*',
            'Authorization': 'Bearer $token'
          }));
      List<KPI> list = [];
      for (final element in response.data) {
        list.add(KPI.fromMap(element));
      }
      return list;
    } on DioError catch (e) {
      return [];
    }
  }
}
