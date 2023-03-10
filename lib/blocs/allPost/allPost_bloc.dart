// ignore_for_file: unused_local_variable, avoid_print

import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/allPost/allPost_state.dart';
import 'package:playfutday_flutter/models/allPost.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:stream_transform/stream_transform.dart';

import 'allPost_event.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AllPostBloc extends Bloc<AllPostEvent, AllPostState> {
  AllPostBloc(this._postService) : super(const AllPostState()) {
    on<AllPostFetched>(
      _onAllPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  // ignore: unused_field
  final PostService _postService;

  Future<void> _onAllPostFetched(
      AllPostFetched event, Emitter<AllPostState> emitter) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == AllPostStatus.initial) {
        page = 0;
        final allPost = await _postService.getAllPosts(page);
        return emitter(state.copyWith(
          status: AllPostStatus.success,
          allPost: allPost!.content,
          hasReachedMax: allPost.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allPost = await _postService.getAllPosts(page);

      emitter(state.copyWith(
          status: AllPostStatus.success,
          allPost: List.of(state.allPost)..addAll(allPost!.content),
          hasReachedMax: allPost.totalPages - 1 <= page));
    } catch (_) {
      emitter(state.copyWith(status: AllPostStatus.failure));
    }
  }

  Future<void> deletePost(String userId, int id) async {
    final deleteInProgress = state.allPost.map((post) {
      // ignore: unrelated_type_equality_checks
      return post.id == id ? state.copyWith() : post;
    }).toList();

    print(deleteInProgress);
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(
        status: AllPostStatus.success,
        allPost: state.allPost,
        hasReachedMax: false));

    unawaited(
      _postService.deletePost(id, userId).then((_) {
        final deleteSuccess = List.of(state.allPost)
          // ignore: unrelated_type_equality_checks
          ..removeWhere((post) => post.id == id);
        // ignore: invalid_use_of_visible_for_testing_member
        emit(state.copyWith(allPost: deleteSuccess));
      }),
    );
  }

  Future<void> sendLiked(int id) async {
    final updatedPosts = await _postService.postLikeByMe(id);

    print(updatedPosts);
    if (updatedPosts == null) {
      throw Exception('No se pudo actualizar el post con ID $id');
    }

    final updatedPostIndex = state.allPost.indexWhere((post) => post.id == id);
    final updatedAllPost = List<Post>.from(state.allPost);
    updatedAllPost[updatedPostIndex] = updatedPosts;

    emit(state.copyWith(
      allPost: updatedAllPost,
    ));
  }

  Future<void> sendCommentarie(String message, int idPost) async {
    // Actualiza el estado para mostrar que se está enviando el comentario
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(status: AllPostStatus.initial));

    // Envía el comentario
    await _postService.sendCommentaries(message, idPost);

    // Recupera la lista actualizada del servicio
    final updatedList = await _postService.getAllPosts();

    // Actualiza el estado con la lista actualizada
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(
      status: AllPostStatus.success,
      allPost: updatedList!.content,
      hasReachedMax: false,
    ));
  }
}
