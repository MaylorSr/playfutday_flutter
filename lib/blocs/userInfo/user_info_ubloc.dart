import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/userInfo/user_info.event.dart';
import 'package:playfutday_flutter/blocs/userInfo/user_info_ustate.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UserInfoDetailsBloc
    extends Bloc<UserInfoDetailEvent, UserInfoDetailState> {
  final AdminRepository _adminRepository;
  // ignore: no_leading_underscores_for_local_identifiers
  UserInfoDetailsBloc(AdminRepository _adminRepository)
      // ignore: unnecessary_null_comparison
      : assert(_adminRepository != null),
        _adminRepository = _adminRepository,
        super(const UserInfoDetailState()) {
    on<UserInfoDetailFetched>(
      _onUserInfoDetailFetched,
    );
  }

  Future<void> _onUserInfoDetailFetched(
    UserInfoDetailFetched event,
    Emitter<UserInfoDetailState> emit,
  ) async {
    if (state.props.isEmpty) return;
    try {
      if (state.status == UserInfoDetailStatus.initial) {
        // ignore: unused_local_variable
        final usersInfoDetails =
            await _adminRepository.fecthUsersInfo(event.id);
        return emit(state.copyWith(
            userDetails: usersInfoDetails,
            status: UserInfoDetailStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: UserInfoDetailStatus.failure));
    }
  }
}
