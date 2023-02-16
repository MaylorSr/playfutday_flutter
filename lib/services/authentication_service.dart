import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/models/user.dart';

import '../config/locator.dart';
import '../models/login.dart';
import '../repositories/authentication_repository.dart';
import '../repositories/user_repository.dart';
import 'localstorage_service.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User> signInWithUserNameAndPassword(String username, String password);
  Future<void> signOut();
}

@Order(2)
//@Singleton(as: AuthenticationService)
@singleton
class JwtAuthenticationService extends AuthenticationService {
  late AuthenticationRepository _authenticationRepository;
  late LocalStorageService _localStorageService;
  late UserRepository _userRepository;

  JwtAuthenticationService() {
    _authenticationRepository = getIt<AuthenticationRepository>();
    _userRepository = getIt<UserRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<User?> getCurrentUser() async {
    //String? loggedUser = _localStorageService.getFromDisk("user");
    print("get current user");
    String? token = _localStorageService.getFromDisk("user_token");
    if (token != null) {
      LoginResponse response = await _userRepository.me();
      return User(avatar: response.avatar, fullName: response.fullName, id: response.id);
    }
    return null;
  }

  @override
  Future<User> signInWithUserNameAndPassword(
      String username, String password) async {
    LoginResponse response =
        await _authenticationRepository.doLogin(username, password);
    await _localStorageService.saveToDisk('user_token', response.token);
    return User(avatar: response.avatar, username: response.username, fullName: response.fullName);
  }

  @override
  Future<void> signOut() async {
    print("borrando token");
    await _localStorageService.deleteFromDisk("user_token");
  }
}
