import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

import '../../models/adminUsers.dart';

enum UserInfoDetailStatus { initial, success, failure }

class UserInfoDetailState extends Equatable {
  const UserInfoDetailState(
      {this.status = UserInfoDetailStatus.initial, this.userDetails});

  final UserInfoDetailStatus status;
  final InfoUser? userDetails;

  UserInfoDetailState copyWith({
    UserInfoDetailStatus? status,
    InfoUser? userDetails,
  }) {
    return UserInfoDetailState(
        status: status ?? this.status,
        userDetails: userDetails ?? this.userDetails);
  }

  @override
  String toString() {
    return '''UserInfoDetailState { status: $status }''';
  }

  @override
  List<Object> get props => [status];
}
