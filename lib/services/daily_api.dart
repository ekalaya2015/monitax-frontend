import 'package:dio/dio.dart';
import 'package:monitax/models/daily.dart';
import 'package:monitax/config.dart';

class DailyApi {
  Future<Daily?> fetchData() async {
    var dio = Dio();
    Response response;
    try {
      response = await dio.get('${Config.apiURL}/invoices/analytics',
          options: Options(contentType: Headers.jsonContentType, headers: {
            'Accept': 'application/json',
            'Access-Control_Allow_Origin': '*',
          }));
      return Daily.fromMap(response.data);
    } on DioError catch (e) {
      return null;
    }
  }
}
