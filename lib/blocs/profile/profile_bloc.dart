import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/profile/profile_event.dart';
import 'package:playfutday_flutter/blocs/profile/profile_state.dart';
import 'package:playfutday_flutter/models/userLogin.dart';
import 'package:playfutday_flutter/repositories/repositories.dart';

import '../../models/post.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(UserRepository userRepository)
      : _userRepository = userRepository,
        super(ProfileState(username: '', biography: '', myPost: [])) {
    on<LoadProfileEvent>((event, emit) async {
      final user = await _userRepository.myInfo();
      UserLogin u = user;
      emit(ProfileState(
        username: '${u.username}',
        biography: '${u.biography}',
        myPost: u.myPost?.cast<Post>() ?? [],
      ));
    });
  }
  final UserRepository _userRepository;
  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadProfileEvent) {
      final user = await _userRepository.myInfo();
      UserLogin u = user;
      yield ProfileState(
        username: '${u.username}',
        biography: '${u.biography}',
        myPost: u.myPost?.cast<Post>() ?? [],
      );
    } else if (event is EditProfileEvent) {
      // Here, you would open the profile editing screen
    } else if (event is ViewPostEvent) {
      // Here, you would open the post viewing screen
    }
  }
}
