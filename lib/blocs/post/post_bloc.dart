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
    on<ResetCounter>(_onResetCounter);
  }

  final PostRepository postRepository;

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;
    contador++;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await postRepository.fetchPosts(contador);
        return emit(
          state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }
      final posts = await postRepository.fetchPosts(contador);
      if (posts.isEmpty && state.status == PostStatus.success) {
        contador = 0; // Reiniciar el contador a 0
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            status: PostStatus.success,
            posts: List.of(state.posts)..addAll(posts),
            hasReachedMax: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  void _onResetCounter(ResetCounter event, Emitter<PostState> emit) {
    contador = 0;
  }
}

class ResetCounter extends PostEvent {
  ResetCounter();
}
