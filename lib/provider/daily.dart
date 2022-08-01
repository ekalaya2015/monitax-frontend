import 'package:monitax/models/daily.dart';
import 'package:monitax/helper/helper.dart';

class DailyProvider {
  final helper = DailyHelper();
  Daily? daily;
  Future<Daily?> get getDaily async {
    Future<Daily?> daily = helper.getDaily();
    return daily;
  }
}
