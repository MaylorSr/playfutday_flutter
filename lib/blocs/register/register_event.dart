import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RegisterInPressed extends RegisterEvent {
  final String username;
  final String password;
  final String veryfyPassword;
  final String email;
  final String phone;

  RegisterInPressed(
      {@required required this.username,
      @required required this.password,
      @required required this.veryfyPassword,
      @required required this.email,
      @required required this.phone});

  @override
  List<Object> get props => [username, password, veryfyPassword, email, phone];
}
