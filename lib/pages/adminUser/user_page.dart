import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/adminUsers.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/adminUser/user_list.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';
import '../../blocs/userListByAdmin/user_Info_bloc.dart';
import '../../blocs/userListByAdmin/user_info_event.dart';
import '../../blocs/userListByAdmin/user_info_state.dart';
import '../../repositories/post_repositories/post_repository.dart';
import '../post/bottom_loader.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final _postRepository = PostRepository();
  final _adminRepository = AdminRepository();
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInfoBloc, UserInfoState>(
      builder: (context, state) {
        switch (state.status) {
          case UserInfoStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.person_2, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    'You do not have any users',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          case UserInfoStatus.success:
            if (state.users.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Any posts found!')),
                ],
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.users.length
                    ? const BottomLoader()
                    : UserListItem(
                        users: state.users[index],
                        postRepository: _postRepository,
                        userAdminRepository: _adminRepository,
                        user: widget.user,
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.users.length
                  : state.users.length + 1,
              controller: _scrollController,
            );
          case UserInfoStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<UserInfoBloc>().add(UserInfoFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
