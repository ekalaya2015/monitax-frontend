import 'package:monitax/services/user_api.dart';
import 'package:monitax/models/user.dart';
import 'package:monitax/models/daily.dart';
import 'package:monitax/services/daily_api.dart';

class UserHelper {
  final api = UserApi();
  Future<User?> getMe() async {
    final result = await api.me();
    if (result != null) {
      return result;
    }
    return null;
  }
}

class DailyHelper {
  final api = DailyApi();
  Future<Daily?> getDaily() async {
    final result = await api.fetchData();
    if (result != null) {
      return result;
    }
    return null;
  }
}
