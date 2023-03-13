// ignore_for_file: override_on_non_overriding_member

import 'package:playfutday_flutter/models/models.dart';

import 'package:playfutday_flutter/repositories/user_repository.dart';
import '../localstorage_service.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@Order(3)
@singleton
class UserService {
  // ignore: unused_field
  late LocalStorageService _localStorageService;
  // ignore: unused_field
  late UserRepository _userRepository;
  // ignore: unused_field

  UserService() {
    _userRepository = GetIt.I.get<UserRepository>();

    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  Future<User?> getMeInfo() async {
    print("get user log");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      UserResponse response = await _userRepository.me();
      // ignore: avoid_print
      print(response);
      return response;
    }
    return null;
  }
  
  Future<dynamic> editBio(String biography) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.editBioByMe(biography);
      // ignore: avoid_print
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);


  Future<http.Response?> editPhone(String phone) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      var response = await _userRepository.editPhoneByMe(phone);
      // ignore: avoid_print
      return response;
    }
    return null;
  }

  
  Future<dynamic> editBirthday(String birthday) async {
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      await _userRepository.editBirthdayByMe(birthday);
      // ignore: avoid_print
    }
  }

}
