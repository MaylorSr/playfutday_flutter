import 'dart:convert';

import 'package:playfutday_flutter/models/register.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
String url_base = "http://localhost:8080/auth/register";

class RegisterRepository {
  Future<http.Response> doRegister(String username, String email, String phone,
      String password, String verifyPassword) async {
    final response = await http.post(Uri.parse(url_base),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'NoAuth'
        },
        body: jsonEncode(RegisterRequest(
          username: username,
          email: email,
          phone: phone,
          password: password,
          verifyPassword: verifyPassword,
        )));
    print(response.statusCode);
    print(response.body);
    return response;
  }
}
