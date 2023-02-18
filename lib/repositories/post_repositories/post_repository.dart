// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/repositories/user_repository.dart';
import 'package:playfutday_flutter/services/services.dart';

import '../../config/locator.dart';
import '../../models/post.dart';
import '../../rest/rest_client.dart';
import 'package:http/http.dart' as http;

/*
URL BASE DE POST*/
// ignore: non_constant_identifier_names
String url_base = "http://localhost:8080";

class PostRepository {
  late RestAuthenticatedClient _client;
  late LocalStorageService _localStorageService;

  PostRepository() {
    _client = getIt<RestAuthenticatedClient>();
    _localStorageService = getIt<LocalStorageService>();
  }

// ignore: no_leading_underscores_for_local_identifiers
  Future<List<Post>> fetchPosts([int _startIndex = -1]) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String page = "/post/?page=${_startIndex}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url_base + page),
      headers: {'Authorization': 'Bearer $token'},
    );

    return PostResponse.fromJson(jsonDecode(response.body)).content
        as List<Post>;
  }

  Future<Image> getImage(String imageName) async {
    String? token = _localStorageService.getFromDisk('user_token');
    String urlImagen = "/download/${imageName}";

    final response = await http.get(
      Uri.parse(url_base + urlImagen),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Image(image: MemoryImage(Uint8List.fromList(response.bodyBytes)));
    } else {
      throw Exception('Failed to load image');
    }
  }
}
