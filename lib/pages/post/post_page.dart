import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/post/post_list.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

import 'bottom_loader.dart';

class PostList extends StatefulWidget {
  const PostList({super.key, required this.user});
  final User user;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();
  final _postRepository = PostRepository();
  final _user = User();
  final _refreshController = Completer<void>(); // Add this line to define the _refreshController

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

   @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text('failed to get posts!')),
              ],
            );
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Any posts found!')),
                ],
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(PostRefresh());
                await _refreshController.future;
              },
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.posts.length
                      ? const BottomLoader()
                      : PostListItem(
                          post: state.posts[index],
                          postRepository: _postRepository,
                          user: _user,
                        );
                },
                scrollDirection: Axis.vertical,
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                controller: _scrollController,
              ),
            );
          case PostStatus.initial:
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
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
