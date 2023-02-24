import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/userListByAdmin/user_info_event.dart';
import 'package:playfutday_flutter/blocs/userListByAdmin/user_info_state.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc(this._adminRepository) : super(const UserInfoState()) {
    on<UserInfoFetched>(
      _onUserInfoFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final AdminRepository _adminRepository;

  Future<void> _onUserInfoFetched(
      UserInfoFetched event, Emitter<UserInfoState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == UserInfoStatus.initial) {
        page = 0;
        final response = await _adminRepository.fecthUsers(page);
        final users = response;
        return emitter(state.copyWith(
          status: UserInfoStatus.success,
          users: users.content,
          hasReachedMax: response.totalPages! - 1 <= page,
        ));
      }
      page += 1;
      final response = await _adminRepository.fecthUsers(page);
      final users = response;

      emitter(state.copyWith(
          status: UserInfoStatus.success,
          users: List.of(state.users)..addAll(users.content!),
          hasReachedMax: response.totalPages! - 1 <= page));
    } catch (_) {
      emitter(state.copyWith(status: UserInfoStatus.failure));
    }
  }
}
