/*import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// ignore: unused_import
import '../models/loginResponse.dart';
import '../rest/rest_client.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
  }

  Future<dynamic> doLogin(String username, String password) async {
    String url = "/auth/login";

    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    /**Mirar si de verdad debería devolver un Longin Response */
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }
}*/

import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:playfutday_flutter/rest/rest.dart';

import '../models/login.dart';
import 'package:http/http.dart' as http;

import '../models/register.dart';
import '../models/user.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<dynamic> doLogin(String username, String password) async {
    String url = "/auth/login";

    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    return User.fromJson(jsonDecode(jsonResponse));
  }

  Future<http.Response> singUp(String username, String email, String phone,
      String password, String verifyPassword) async {
    String url = "/auth/register";

    var jsonResponse = await _client.singUpPost(
        url,
        RegisterRequest(
            username: username,
            email: email,
            phone: phone,
            password: password,
            verifyPassword: verifyPassword));
    return jsonResponse;
  }
}
