import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitax/screens/login.dart';
import 'package:monitax/models/user.dart';
import 'package:provider/provider.dart';
// import 'package:scoped_model/scoped_model.dart';
import 'package:monitax/provider/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MonitaxApp(title: 'Monitax'));
}

// ignore: must_be_immutable
class MonitaxApp extends StatelessWidget {
  String title = '';
  MonitaxApp({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Monitax',
        home: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            home: const LoginScreen()));
  }
}
