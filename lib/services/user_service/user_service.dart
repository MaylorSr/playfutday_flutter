// ignore_for_file: override_on_non_overriding_member

import 'package:playfutday_flutter/models/models.dart';

import 'package:playfutday_flutter/repositories/user_repository.dart';
import '../localstorage_service.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
