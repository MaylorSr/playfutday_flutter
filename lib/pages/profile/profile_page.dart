import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/profile/profile_bloc.dart';
import 'package:playfutday_flutter/blocs/profile/profile_state.dart';
import 'package:playfutday_flutter/pages/profile/profile.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../models/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // ignore: unused_field
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        switch (state.status) {
          case ProfileStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.person_2_rounded, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    'Not found your profile',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          case ProfileStatus.success:
            if (state.status.toString().isEmpty) {
              return const Center(child: Text('No exists info of that user'));
            }
            return ProfileUser(
              user: state.user!,
              postService: PostService(),
            );

          case ProfileStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case ProfileStatus.editProfile:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
