import 'package:dio/dio.dart';
import 'package:monitax/models/dailyinv.dart';
import 'package:monitax/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyInvoiceApi {
  Future<DailyInvoice?> fetchData() async {
    var dio = Dio();
    Response response;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      response = await dio.get('${Config.apiURL}/invoices/daily',
          options: Options(contentType: Headers.jsonContentType, headers: {
            'Accept': 'application/json',
            'Access-Control_Allow_Origin': '*',
            'Authorization': 'Bearer $token'
          }));
      return DailyInvoice.fromMap(response.data);
    } on DioError catch (e) {
      return null;
    }
  }
}
