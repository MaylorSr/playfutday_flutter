import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/models/favPost.dart';
import 'package:playfutday_flutter/models/models.dart';

import '../../config/locator.dart';
import '../../rest/rest_client.dart';

@Order(-1)
@singleton
class PostRepository {
  late RestAuthenticatedClient _client;

  PostRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<PostResponse> allPost([int index = 0]) async {
    String url = "/post/?page=$index";

    var jsonResponse = await _client.get(url);

    return PostResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<PostResponse> myAllPost([int index = 0]) async {
    String url = "/post/user?page=$index";

    var jsonResponse = await _client.get(url);

    return PostResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<PostFavResponse> allFavPost([int index = 0]) async {
    String url = "/fav/?page=$index";

    var jsonResponse = await _client.get(url);

    return PostFavResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<void> deletePost(int idPost, String userId) async {
    String url = "/post/user/$idPost/user/$userId";
    // ignore: avoid_print
    print(idPost);
    // ignore: unused_local_variable
    var jsonResponse = await _client.deleteP(url);
  }

  Future<Post> postLike(int idPost) async {
    String url = "/post/like/$idPost";

    var jsonResponse = await _client.post(url, jsonEncode(idPost));
    return Post.fromJson(jsonDecode(jsonResponse));
  }

  Future<Post> sendComment(String message, int idPost) async {
    String url = "/post/commentary/$idPost";

    var jsonResponse = await _client.post(url, jsonEncode(message));
    return Post.fromJson(jsonDecode(jsonResponse));
  }

  Future<MyFavPost> postLikeFav(int idPost) async {
    String url = "/post/like/$idPost";

    var jsonResponse = await _client.post(url, jsonEncode(idPost));
    return MyFavPost.fromJson(jsonDecode(jsonResponse));
  }
}
