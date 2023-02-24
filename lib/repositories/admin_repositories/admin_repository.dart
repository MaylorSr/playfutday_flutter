/*
URL BASE DE POST*/
// ignore: non_constant_identifier_names
import 'dart:convert';

import 'package:playfutday_flutter/models/adminUsers.dart';
import 'package:playfutday_flutter/models/models.dart';

import '../../config/locator.dart';
import '../../rest/rest_client.dart';
import '../../services/localstorage_service.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
String url_base = "http://localhost:8080";

class AdminRepository {
  late RestAuthenticatedClient _client;
  late LocalStorageService _localStorageService;

  AdminRepository() {
    _client = getIt<RestAuthenticatedClient>();
    _localStorageService = getIt<LocalStorageService>();
  }

// ignore: no_leading_underscores_for_local_identifiers
  Future<UserResponseAdmin> fecthUsers([int _startIndex = 0]) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String page = "/user/?page=${_startIndex}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url_base + page),
      headers: {'Authorization': 'Bearer $token'},
    );
    return UserResponseAdmin.fromJson(jsonDecode(response.body));
  }

  Future<InfoUser> fecthUsersInfo(String uuid) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String url = "/info/user/${uuid}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url_base + url),
      headers: {'Authorization': 'Bearer $token'},
    );
    return InfoUser.fromJson(jsonDecode(response.body));
  }

  Future<dynamic> banUser(String uuid) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String url = "/banUserByAdmin/${uuid}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.post(
      Uri.parse(url_base + url),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
  }

  Future<dynamic> changeRole(String uuid) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String url = "/changeRole/${uuid}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.post(
      Uri.parse(url_base + url),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
  }

  Future<dynamic> deleteUserOrMe(String uuid) async {
    String url = "/user/$uuid";
    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.delete(Uri.parse(url_base + url), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain'
    });
    print(response.statusCode);
  }
}
