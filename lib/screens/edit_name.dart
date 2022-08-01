import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monitax/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:monitax/screens/profile.dart';

class EditName extends StatefulWidget {
  EditName({Key? key}) : super(key: key);

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  final _formkey = GlobalKey<FormState>();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  late bool isLoading = false;
  bool isUpdated = false;

  doUpdate() async {
    setState(() {
      isLoading = true;
      isUpdated = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = '${Config.apiURL}/users/me/profile';
    final body = jsonEncode(
        {'first_name': txtFirstName.text, 'last_name': txtLastName.text});
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
          context, const CustomSnackBar.success(message: 'Update success'));
    } else {
      // ignore: use_build_context_synchronously
      showTopSnackBar(
          context, const CustomSnackBar.error(message: 'update failed'));
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isUpdated = false;
    });
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
          title: const Text('Edit Name'),
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
                      padding: const EdgeInsets.only(top: 20, left: 40),
                      child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration:
                              const InputDecoration(labelText: 'First name'),
                          controller: txtFirstName,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 40),
                      child: SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: txtLastName,
                          keyboardType: TextInputType.name,
                          decoration:
                              const InputDecoration(labelText: 'Last name'),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
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
                          ))),
                )
              ]),
        ));
  }
}
