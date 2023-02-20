import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/fav/post_listFav.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

import '../../blocs/fav/fav_bloc.dart';
import '../../blocs/fav/fav_event.dart';
import '../../blocs/fav/fav_state.dart';
import '../post/bottom_loader.dart';

class PostListFav extends StatefulWidget {
  const PostListFav({super.key});

  @override
  State<PostListFav> createState() => _PostListFavState();
}

class _PostListFavState extends State<PostListFav> {
  final _scrollController = ScrollController();
  final _postRepository = PostRepository();
  final _user = User();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavBloc, FavState>(
      builder: (context, state) {
        switch (state.status) {
          case FavStatus.failure:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(child: Text('failed to get posts!')),
                ElevatedButton(
                  onPressed: () {
                    context.read<FavBloc>().add(ResetCounter());
                    context.read<FavBloc>().add(FavFetched());
                  },
                  child: const Text('Try Again'),
                ),
              ],
            );
          case FavStatus.success:
            if (state.fav.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Any posts found!')),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavBloc>().add(ResetCounter());
                      context.read<FavBloc>().add(FavFetched());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.fav.length
                    ? const BottomLoader()
                    : PostListItemFav(
                        post: state.fav[index],
                        postRepository: _postRepository,
                        user: _user,
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount:
                  state.hasReachedMax ? state.fav.length : state.fav.length + 1,
              controller: _scrollController,
            );
          case FavStatus.initial:
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
    if (_isBottom) context.read<FavBloc>().add(FavFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
