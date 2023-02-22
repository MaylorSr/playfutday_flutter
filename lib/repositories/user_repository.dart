import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/models/userLogin.dart';

import '../config/locator.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../rest/rest_client.dart';
import 'package:http/http.dart' as http;

import '../services/localstorage_service.dart';

// ignore: non_constant_identifier_names
String url_base = "http://localhost:8080";

@Order(-1)
@singleton
class UserRepository {
  late RestAuthenticatedClient _client;
  late LocalStorageService _localStorageService;

  UserRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> me() async {
    String url = "/me";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> myInfo() async {
    String url = "/me";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url_base + url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);
    return UserLogin.fromJson(jsonDecode(response.body));
  }


}
