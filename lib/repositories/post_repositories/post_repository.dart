import 'dart:convert';

import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/repositories/user_repository.dart';
import 'package:playfutday_flutter/services/services.dart';

import '../../config/locator.dart';
import '../../models/post.dart';
import '../../rest/rest_client.dart';
import 'package:http/http.dart' as http;

/*
URL BASE DE POST*/
String url = "http://localhost:8080/post/";

class PostRepository {
  late RestAuthenticatedClient _client;
  late LocalStorageService _localStorageService;

  PostRepository() {
    _client = getIt<RestAuthenticatedClient>();
    _localStorageService = getIt<LocalStorageService>();
  }

  Future<List<Post>> fetchPosts([int _startIndex = 0]) async {

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      return PostResponse.fromJson(jsonDecode(response.body)).content as List<Post>;
    } else {
      throw Exception('Error fetching posts');
    }
  }
}