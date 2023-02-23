import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

var contador = -1;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc(this.postRepository) : super(const PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final PostRepository postRepository;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == PostStatus.initial) {
        contador = 0;
        final response = await postRepository.fetchPosts(contador);
        final posts = response;
        return emitter(state.copyWith(
          status: PostStatus.success,
          posts: posts.content,
          hasReachedMax: response.totalPages - 1 <= contador,
        ));
      }
      contador += 1;
      final response = await postRepository.fetchPosts(contador);
      final posts = response;

      emitter(state.copyWith(
          status: PostStatus.success,
          posts: List.of(state.posts)..addAll(posts.content!),
          hasReachedMax: response.totalPages - 1 <= contador));
    } catch (_) {
      emitter(state.copyWith(status: PostStatus.failure));
    }
  }
}
