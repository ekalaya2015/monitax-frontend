import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

class Config {
  Config() {
    initializeDateFormatting('id_ID', '');
  }
  static const apiURL = 'https://raspi-geek.tech/api/v1';
  static NumberFormat formatCurrency =
      NumberFormat.simpleCurrency(locale: 'id-ID');
  static DateFormat formatDate = DateFormat('yyyy-MM-dd H:m:s');
}
