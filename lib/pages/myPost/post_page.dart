import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../blocs/myPost/myPost_bloc.dart';
import '../../models/user.dart';
import '../allPost/all_Post_List.dart';
import '../allPost/bottom_loader.dart';

class MyPostList extends StatefulWidget {
  const MyPostList({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<MyPostList> createState() => _AllPostListState();
}

class _AllPostListState extends State<MyPostList> {
  final _scrollController = ScrollController();
  // ignore: unused_field
  final _postService = PostService();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPostBloc, AllPostState>(
      builder: (context, state) {
        switch (state.status) {
          case AllPostStatus.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.sports_soccer, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    'Not found any posts',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          case AllPostStatus.success:
            if (state.allPost.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Any posts found!')),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MyPostBloc>().add(AllPostFetched());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.allPost.length
                    ? const BottomLoader()
                    : AllPostListItem(
                        post: state.allPost[index],
                        postService: _postService,
                        user: widget.user,
                        onDeletePressed: (userId, id) {
                          context.read<MyPostBloc>().deletePost(userId, id);
                        },
                        onSendCommentariePressed: (message, idPost) {},
                        onSendLikedPressed: (idPost) {
                          context.read<MyPostBloc>().sendLiked(idPost);
                        },
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.allPost.length
                  : state.allPost.length + 1,
              controller: _scrollController,
            );
          case AllPostStatus.initial:
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
    if (_isBottom) context.read<MyPostBloc>().add(AllPostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
