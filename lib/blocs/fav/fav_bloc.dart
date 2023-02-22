import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:playfutday_flutter/blocs/fav/fav.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
//import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';


//const _artworkLimit = 20;
const throttleDuration = Duration(milliseconds: 100);


EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FavBloc extends Bloc<FavEvent, FavState> {
  FavBloc(this._postRepository) : super(const FavState()) {
    on<FavFetched>(
      _onFavFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }
  
    final PostRepository _postRepository;



  Future<void> _onFavFetched(
    FavFetched event,
    Emitter<FavState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == FavStatus.initial) {
        final myFavPosts = await _postRepository.getMyPost();
        return emit(
          state.copyWith(
            status: FavStatus.success,
            fav: myFavPosts,
            hasReachedMax: false,
          ),
        );
      }
      //final artworks = await _fetchArtworks(state.artworks.length);
      final artworks = await _postRepository.getMyPost(state.fav.length);
      artworks.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: FavStatus.success,
                fav: List.of(state.fav)..addAll(artworks),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: FavStatus.failure));
    }
  }
  
}