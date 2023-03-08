import 'dart:convert';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
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

  Future<void> deletePost(int idPost, String userId) async {
    String url = "/post/user/$idPost/user/$userId";
    print(idPost);
    // ignore: unused_local_variable
    var jsonResponse = await _client.deleteP(url);
  }
}
