// ignore_for_file: unused_local_variable, unnecessary_cast

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:playfutday_flutter/models/favPost.dart';
import 'package:playfutday_flutter/models/models.dart';
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

    print(response.statusCode);

    return PostResponse.fromJson(jsonDecode(response.body)).content
        as List<Post>;
  }

// ignore: no_leading_underscores_for_local_identifiers
  Future<List<Content>> fetchPostsFav([int _startIndex = 0]) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String page = "/fav?page=${_startIndex}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url_base + page),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(response.body);
    return PostFav.fromJson(jsonDecode(response.body)).content as List<Content>;
  }

  Future<Image> getImage(String imageName) async {
    String? token = _localStorageService.getFromDisk('user_token');
    // ignore: unnecessary_brace_in_string_interps
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

  Future<bool> postLikeByMe(int idPost) async {
    String? token = _localStorageService.getFromDisk('user_token');
    String urlLike = "/post/like/$idPost";

    final response = await http.post(Uri.parse(url_base + urlLike),
        headers: {'Authorization': 'Bearer $token'}, body: jsonEncode(idPost));
    print('The status code of your peticion are:');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 201) return true;
    return false;
  }

  // ignore: no_leading_underscores_for_local_identifiers
  Future<List<Post>> getMyPost([int _startIndex = -1]) async {
// ignore: unnecessary_brace_in_string_interps, unused_local_variable
    String page = "/post/user?page=${_startIndex}";

    String? token = _localStorageService.getFromDisk('user_token');

    final response = await http.get(
      Uri.parse(url_base + page),
      headers: {'Authorization': 'Bearer $token'},
    );

    // ignore: avoid_print
    print(response.statusCode);
    return PostResponse.fromJson(jsonDecode(response.body)).content
        as List<Post>;
  }

  Future<dynamic> sendCommentaries(String message, int idPost) async {
    String? token = _localStorageService.getFromDisk('user_token');

    String urlPostToCommentaries = "/post/commentary/$idPost";
    final response =
        await http.post(Uri.parse(url_base + urlPostToCommentaries),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json, text/plain'
            },
            body: jsonEncode({'message': message}));
    print(response.body);
    if (response.statusCode == 201) return true;
    return false;
  }

  Future<dynamic> deletePostByAdmin(int idPost, String userId) async {
    String? token = _localStorageService.getFromDisk('user_token');

    String urlDeletePost =
        // ignore: unnecessary_brace_in_string_interps
        "/post/user/$idPost/user/$userId";
    final response =
        await http.delete(Uri.parse(url_base + urlDeletePost), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain'
    });
    print(response.statusCode);
  }
}
