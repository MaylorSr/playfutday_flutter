import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/models.dart';

enum ProfileStatus { initial, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
  });

  final ProfileStatus status;
  final User? user;

  ProfileState copyWith({
    ProfileStatus? status,
    final User? user,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return '''ProfileState { status: $status, user: $user }''';
  }

  @override
  List<Object> get props => [status];
}
