import 'package:equatable/equatable.dart';

abstract class UserInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInfoFetched extends UserInfoEvent {}