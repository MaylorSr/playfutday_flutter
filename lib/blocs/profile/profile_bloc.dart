import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/profile/profile_event.dart';
import 'package:playfutday_flutter/blocs/profile/profile_state.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._userService) : super(const ProfileState()) {
    on<ProfileFetched>(
      _onProfileFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  // ignore: unused_field
  final UserService _userService;

  // ignore: unused_element
  Future<void> _onProfileFetched(
      ProfileFetched event, Emitter<ProfileState> emitter) async {
    try {
      if (state.status == ProfileStatus.initial) {
        final user = await _userService.getMeInfo();
        return emitter(state.copyWith(
          status: ProfileStatus.success,
          user: user!,
        ));
      }
      final user = await _userService.getMeInfo();

      emitter(state.copyWith(
        status: ProfileStatus.success,
        user: user,
      ));
    } catch (_) {
      emitter(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
