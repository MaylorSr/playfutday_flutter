// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:playfutday_flutter/services/services.dart';

import '../../config/locator.dart';
import '../../models/post.dart';
import '../../rest/rest_client.dart';
import 'package:http/http.dart' as http;

/*
URL BASE DE POST*/
// ignore: non_constant_identifier_names
String url_base = "http://localhost:8080";

class SearchRepositories {
  // ignore: unused_field
  late RestAuthenticatedClient _client;
  late LocalStorageService _localStorageService;

  SearchRepositories() {
    _client = getIt<RestAuthenticatedClient>();
    _localStorageService = getIt<LocalStorageService>();
  }

  // ignore: unused_element
  Future<List<Post>> searchRepositories(String query) async {
    String? token = _localStorageService.getFromDisk('user_token');
    String search = "/post/?s=tag:${query.toLowerCase()}";

    final response = await http.get(
      Uri.parse(url_base + search),
      headers: {'Authorization': 'Bearer $token'},
    );

    return PostResponse.fromJson(jsonDecode(response.body)).content
        as List<Post>;
  }
}
