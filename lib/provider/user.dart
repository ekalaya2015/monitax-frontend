import 'package:monitax/models/user.dart';
import 'package:monitax/helper/helper.dart';

class UserProvider {
  final helper = UserHelper();
  User? user;
  Future<User?> get getUser async {
    Future<User?> user = helper.getMe();
    return user;
  }
}
