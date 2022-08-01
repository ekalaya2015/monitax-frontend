import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:monitax/screens/home.dart';
import 'package:monitax/services/user_api.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      footer: '2022  \u00a9 Raspigeek',
      theme: LoginTheme(
          pageColorLight: Color.fromARGB(255, 105, 176, 241),
          pageColorDark: Color.fromARGB(255, 107, 248, 94),
          titleStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      scrollable: true,
      title: 'Monitax',
      messages: LoginMessages(
          loginButton: 'Sign in',
          passwordHint: 'Password',
          userHint: 'Username or email'),
      logo: const AssetImage('assets/images/monitax.png'),
      onLogin: UserApi().login,
      onSubmitAnimationCompleted: () {
        UserApi().me();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      },
      onRecoverPassword: UserApi().forgot_password,
      onSignup: UserApi().registration,
      loginAfterSignUp: false,
      additionalSignupFields: const <UserFormField>[
        UserFormField(
            keyName: 'nik', icon: Icon(Icons.abc), displayName: 'NIK'),
        UserFormField(
            keyName: 'phone_no',
            displayName: 'Phone',
            icon: Icon(Icons.phone),
            userType: LoginUserType.phone),
      ],
    );
  }
}
