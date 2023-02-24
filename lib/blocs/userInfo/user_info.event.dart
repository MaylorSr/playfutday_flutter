import 'package:equatable/equatable.dart';

abstract class UserInfoDetailEvent extends Equatable {
  const UserInfoDetailEvent();

  @override
  List<Object> get props => [];
}

class UserInfoDetailFetched extends UserInfoDetailEvent {
  const UserInfoDetailFetched(this.id);
  final String id;
}
