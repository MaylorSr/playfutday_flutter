import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:playfutday_flutter/blocs/allPost/allPost_state.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/allPost.dart';
import '../allPost/allPost_event.dart';

const throttleDuration = Duration(milliseconds: 100);
int page = -1;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MyPostBloc extends Bloc<AllPostEvent, AllPostState> {
  MyPostBloc(this._postService) : super(const AllPostState()) {
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
        final allPost = await _postService.getMyPosts(page);
        return emitter(state.copyWith(
          status: AllPostStatus.success,
          allPost: allPost!.content,
          hasReachedMax: allPost.totalPages - 1 <= page,
        ));
      }
      page += 1;
      final allPost = await _postService.getMyPosts(page);

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

    // ignore: avoid_print
    print(deleteInProgress);
    // ignore: invalid_use_of_visible_for_testing_member
    /*emit(AllPostState.success(deleteInProgress));*/
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

  Future<void> sendCommentarie(String message, int idPost) async {
    final sendCommentarieInProgress = state.allPost.map((post) {
      // ignore: unrelated_type_equality_checks
      return post.id == idPost ? state.copyWith() : post;
    }).toList();

    print(sendCommentarieInProgress);
    // ignore: invalid_use_of_visible_for_testing_member
    /*emit(AllPostState.success(deleteInProgress));*/
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(
        status: AllPostStatus.success,
        allPost: state.allPost,
        hasReachedMax: false));

    unawaited(
      _postService.sendCommentaries(message, idPost).then((_) {
        final sendCommentariesSuccess = List.of(state.allPost)
          // ignore: unrelated_type_equality_checks
          ..removeWhere((post) => post.id == idPost);
        // ignore: invalid_use_of_visible_for_testing_member
        emit(state.copyWith(allPost: sendCommentariesSuccess));
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

    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(
      allPost: updatedAllPost,
    ));
  }
}
