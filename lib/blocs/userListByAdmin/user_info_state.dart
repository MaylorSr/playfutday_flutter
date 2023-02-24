import 'package:equatable/equatable.dart';

import '../../models/adminUsers.dart';

enum UserInfoStatus { initial, success, failure }

class UserInfoState extends Equatable {
  const UserInfoState({
    this.status = UserInfoStatus.initial,
    this.users = const <InfoUser>[],
    this.hasReachedMax = false,
  });

  final UserInfoStatus status;
  final List<InfoUser> users;
  final bool hasReachedMax;

  UserInfoState copyWith({
    UserInfoStatus? status,
    List<InfoUser>? users,
    bool? hasReachedMax,
  }) {
    return UserInfoState(
      status: status ?? this.status,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''UsersState { status: $status, hasReachedMax: $hasReachedMax, posts: ${users.length} }''';
  }

  @override
  List<Object> get props => [status, users, hasReachedMax];
}
