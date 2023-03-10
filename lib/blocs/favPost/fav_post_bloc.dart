import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:stream_transform/stream_transform.dart';

import 'fav_Post_event.dart';
import 'fav_Post_state.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FavBloc extends Bloc<FavEvent, FavState> {
  FavBloc(this.postService) : super(const FavState()) {
    on<FavFetched>(
      _onFavFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final PostService postService;

  Future<void> _onFavFetched(
      FavFetched event, Emitter<FavState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == FavStatus.initial) {
        page = 0;
        final response = await postService.fetchPostsFav(page);
        final favPosts = response;
        return emitter(state.copyWith(
          status: FavStatus.success,
          favPosts: favPosts!.content,
          hasReachedMax: response!.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final response = await postService.fetchPostsFav(page);
      final favPosts = response;

      emitter(state.copyWith(
          status: FavStatus.success,
          favPosts: List.of(state.favPosts)..addAll(favPosts!.content!),
          hasReachedMax: response!.totalPages - 1 <= page));
    } catch (_) {
      emitter(state.copyWith(status: FavStatus.failure));
    }
  }

  Future<void> deletePost(String userId, int id) async {
    final deleteInProgress = state.favPosts.map((post) {
      // ignore: unrelated_type_equality_checks
      return post.id == id ? state.copyWith() : post;
    }).toList();

    print(deleteInProgress);
    // ignore: invalid_use_of_visible_for_testing_member
    /*emit(AllPostState.success(deleteInProgress));*/
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(
        status: FavStatus.success,
        favPosts: state.favPosts,
        hasReachedMax: false));

    unawaited(
      postService.deletePost(id, userId).then((_) {
        final deleteSuccess = List.of(state.favPosts)
          // ignore: unrelated_type_equality_checks
          ..removeWhere((post) => post.id == id);
        // ignore: invalid_use_of_visible_for_testing_member
        emit(state.copyWith(favPosts: deleteSuccess));
      }),
    );
  }
}
