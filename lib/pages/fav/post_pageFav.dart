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
  const PostListFav({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<PostListFav> createState() => _PostListFavState();
}

class _PostListFavState extends State<PostListFav> {
  final _scrollController = ScrollController();
  final _postRepository = PostRepository();
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Icon(Icons.sports_soccer, size: 50),
                  const SizedBox(height: 20),
                  const Text(
                    'You do not have any favorite posts',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          case FavStatus.success:
            if (state.favPosts.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Any posts found!')),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavBloc>().add(FavFetched());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.favPosts.length
                    ? const BottomLoader()
                    : PostListItemFav(
                        post: state.favPosts[index],
                        postRepository: _postRepository,
                        user: widget.user,
                      );
              },
              scrollDirection: Axis.vertical,
              itemCount: state.hasReachedMax
                  ? state.favPosts.length
                  : state.favPosts.length + 1,
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
