import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/userInfo/user_info_ubloc.dart';
import '../../blocs/userInfo/user_info_ustate.dart';
import '../../repositories/post_repositories/post_repository.dart';
import 'details_info.dart';

class UserInfoDetailsL extends StatefulWidget {
  UserInfoDetailsL({super.key});

  @override
  State<UserInfoDetailsL> createState() => _UserInfoDetailsState();
}

class _UserInfoDetailsState extends State<UserInfoDetailsL> {
  final postRepository = PostRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoDetailsBloc, UserInfoDetailState>(
      builder: (context, state) {
        switch (state.status) {
          case UserInfoDetailStatus.failure:
            return const Center(child: Text('failed to fetch details of user'));
          case UserInfoDetailStatus.success:
            if (state.status.toString().isEmpty) {
              return const Center(
                  child: Text('No exists details like this user'));
            }
            return DetailsUser(
              details: state.userDetails!,
              postRepository: postRepository,
            );
          case UserInfoDetailStatus.initial:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
