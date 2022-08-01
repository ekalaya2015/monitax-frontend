import 'dart:io';

import 'package:dio/dio.dart';
import 'package:monitax/config.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserApi {
  Future<String?> login(LoginData data) async {
    var dio = Dio();
    Response response;
    String? retval;
    try {
      response = await dio.post('${Config.apiURL}/auth/access-token',
          data: {'username': data.name, 'password': data.password},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            'Accept': 'application/json',
            'Access-Control_Allow_Origin': '*',
          }));
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('token', response.data['access_token']);
      // token = response.data['access_token'];
      retval = null;
    } on DioError catch (e) {
      retval = e.response.toString();
    }
    return retval;
  }

  Future<String?> registration(SignupData data) async {
    var dio = Dio();
    Response response;
    String? retval;
    Map<String?, String?> post_data = {
      'username': data.name,
      'password': data.password
    };

    post_data.addEntries(data.additionalSignupData!.entries);
    try {
      response = await dio.post('${Config.apiURL}/users/register',
          data: post_data,
          options: Options(contentType: Headers.jsonContentType, headers: {
            'Accept': 'application/json',
            'Access-Control_Allow_Origin': '*',
          }));
      retval = null;
    } on DioError catch (e) {
      retval = e.response.toString();
    }
    return retval;
  }

  Future<String?> forgot_password(String username) async {
    var dio = Dio();
    Response response;
    String? retval;
    try {
      response = await dio.post('${Config.apiURL}/users/forgot-password',
          data: {'username': username},
          options: Options(contentType: Headers.jsonContentType, headers: {
            'Accept': 'application/json',
            'Access-Control_Allow_Origin': '*',
          }));
      retval = null;
    } on DioError catch (e) {
      retval = e.response.toString();
    }
    return retval;
  }

  Future<User?> me() async {
    var dio = Dio();
    Response response;
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      response = await dio.get('${Config.apiURL}/users/me',
          options: Options(contentType: Headers.jsonContentType, headers: {
            'Access-Control_Allow_Origin': '*',
            'Authorization': 'Bearer $token'
          }));
      return User.fromMap(response.data);
    } on DioError catch (e) {
      return null;
    }
  }

  Future<String> upload(File file) async {
    var dio = Dio();
    Response response;
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    response = await dio.post("${Config.apiURL}/users/upload",
        data: formData,
        options: Options(headers: {
          'Content-Type': 'multipart/form-data',
          'Access-Control_Allow_Origin': '*',
          'Authorization': 'Bearer $token'
        }));
    return response.data['pic'];
  }
}
