// ignore_for_file: override_on_non_overriding_member

import 'package:playfutday_flutter/models/models.dart';

import 'package:playfutday_flutter/repositories/post_repository/post_repository.dart';
import '../localstorage_service.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@Order(2)
@singleton
class PostService {
  // ignore: unused_field
  late LocalStorageService _localStorageService;
  late PostRepository _postRepository;
  // ignore: unused_field

  PostService() {
    _postRepository = GetIt.I.get<PostRepository>();

    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<PostResponse?> getAllPosts([int page = 0]) async {
    // ignore: avoid_print
    print("get all posts");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      PostResponse response = await _postRepository.allPost(page);
      // ignore: avoid_print
      print(response.content);
      return response;
    }
    return null;
  }

  Future<void> deletePost(int idPost, String userId) async {
    String? token = _localStorageService.getFromDisk('user_token');
    if (token != null) {
      _postRepository.deletePost(idPost, userId);
    }
    // ignore: avoid_returning_null_for_void
    return null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
