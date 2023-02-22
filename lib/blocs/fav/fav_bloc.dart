/*import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/blocs/fav/fav.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/favPost.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FavBloc extends Bloc<FavEvent, FavState> {
  FavBloc(this.postRepository) : super(const FavState()) {
    on<FavFetched>(
      _onFavFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final PostRepository postRepository;

  Future<void> _onFavFetched(
      FavFetched event, Emitter<FavState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == FavStatus.initial) {
        page = 0;
        final response = await postRepository.getMyPost(page);
        final favPosts = response;
        return emitter(state.copyWith(
          status: FavStatus.success,
          favPosts: favPosts
              .map((post) => MyFavPost(
                    tag: post.tag,
                    image: post.image,
                    author: post.author,
                    authorFile: post.authorFile,
                    countLikes: post.countLikes,
                  ))
              .toList(),
          hasReachedMax: response.length - 1 <= page,
        ));
      }
      page += 1;
      final response = await postRepository.getMyPost(page);
      final favPosts = response;
      emitter(state.copyWith(
          status: FavStatus.success,
          favPosts: List.of(state.favPosts)
            ..addAll(favPosts.map((post) => MyFavPost(
                  tag: post.tag,
                  image: post.image,
                  author: post.author,
                  authorFile: post.authorFile,
                  countLikes: post.countLikes,
                ))),
          hasReachedMax: response.length - 1 <= page));
    } catch (_) {
      emitter(state.copyWith(status: FavStatus.failure));
    }
  }
}
*/