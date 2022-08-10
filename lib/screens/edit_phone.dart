// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:frontend/utils/util.dart';
import 'package:monitax/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:monitax/config.dart';

class EditPhone extends StatefulWidget {
  final String phoneno;
  EditPhone({Key? key, required this.phoneno}) : super(key: key);

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  final _formkey = GlobalKey<FormState>();
  final txtPhone = TextEditingController();
  late bool isLoading = false;
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    txtPhone.text = widget.phoneno;
    setState(() {
      isUpdated = false;
    });
  }

  doUpdate() async {
    setState(() {
      isLoading = true;
      isUpdated = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = '${Config.apiURL}/users/me/profile';
    final body = jsonEncode({'phone_no': txtPhone.text});
    final response = await http
        .patch(Uri.parse(url),
            headers: {
              'accept': 'application/json',
              'content-type': 'application/json',
              'Access-Control_Allow_Origin': '*',
              'Authorization': 'Bearer $token'
            },
            body: body,
            encoding: Encoding.getByName('utf-8'))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context, CustomSnackBar.success(message: 'Update success'));
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(context, CustomSnackBar.error(message: 'Update failed'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isUpdated) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Profile(),
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Icon(Icons.arrow_back),
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Edit Phone'),
        ),
        body: Form(
          key: _formkey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 40),
                      child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              labelText: 'Phone', prefixText: '+62'),
                          controller: txtPhone,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 32,
                        child: ElevatedButton(
                          child: (isLoading)
                              ? const SizedBox(
                                  width: 16,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ))
                              : const Text(
                                  'Update',
                                  style: TextStyle(fontSize: 16),
                                ),
                          onPressed: () {
                            doUpdate();
                          },
                        ),
                      )),
                )
              ]),
        ));
  }
}
