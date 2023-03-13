import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/pages/editProfile/edit_bio.dart';
import 'package:playfutday_flutter/pages/editProfile/edit_profile.dart';

import '../config/locator.dart';
import '../models/editProfile.dart';
import '../models/user.dart';
import '../rest/rest_client.dart';
import 'package:http/http.dart' as http;

@Order(-1)
@singleton
class UserRepository {
  late RestAuthenticatedClient _client;

  UserRepository() {
    _client = getIt<RestAuthenticatedClient>();
  }

  Future<dynamic> me() async {
    String url = "/me";

    var jsonResponse = await _client.get(url);
    return UserResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<dynamic> editBioByMe(String biography) async {
    String url = "/edit/bio";
    EditProfileResponse request = EditProfileResponse(biography: biography);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<http.Response> editPhoneByMe(String phone) async {
    String url = "/edit/phone";
    EditProfileResponse request = EditProfileResponse(phone: phone);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }

  Future<dynamic> editBirthdayByMe(String birthday) async {
    String url = "/edit/birthday";
    EditProfileResponse request = EditProfileResponse(birthday: birthday);

    var jsonResponse = await _client.put(url, request.toJson());
    return jsonResponse;
  }
}
