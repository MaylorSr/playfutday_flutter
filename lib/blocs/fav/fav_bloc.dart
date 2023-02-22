import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import 'fav_event.dart';
import 'fav_state.dart';

var contador = 0;
const throttleDuration = Duration(milliseconds: 100);

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
    on<ResetCounter>(_onResetCounter);
  }

  final PostRepository postRepository;

  Future<void> _onFavFetched(
    FavFetched event,
    Emitter<FavState> emit,
  ) async {
    if (state.hasReachedMax) return;
    contador++;
    try {
      if (state.status == FavStatus.initial) {
        final fav = await postRepository.fetchPostsFav(contador);
        return emit(
          state.copyWith(
            status: FavStatus.success,
            favs: fav,
            hasReachedMax: false,
          ),
        );
      }
      final fav = await postRepository.fetchPostsFav(contador);
      if (fav.isEmpty && state.status == FavStatus.success) {
        contador = 0; 
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(
          state.copyWith(
            status: FavStatus.success,
            favs: List.of(state.fav)..addAll(fav),
            hasReachedMax: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: FavStatus.failure));
    }
  }

  void _onResetCounter(ResetCounter event, Emitter<FavState> emit) {
    contador = -1;
  }
}

class ResetCounter extends FavEvent {
  ResetCounter();
}
