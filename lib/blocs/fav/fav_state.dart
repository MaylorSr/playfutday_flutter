import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/favPost.dart';
import 'package:playfutday_flutter/models/post.dart';

enum FavStatus { initial, success, failure }

class FavState extends Equatable {
  const FavState({
    this.status = FavStatus.initial,
    this.fav = const <MyFavPost>[],
    this.hasReachedMax = false,
  });

  final FavStatus status;
  final List<MyFavPost> fav;
  final bool hasReachedMax;

  FavState copyWith({
    FavStatus? status,
    List<MyFavPost>? favs,
    bool? hasReachedMax, required List<MyFavPost> fav,
  }) {
    return FavState(
      status: status ?? this.status,
      fav: fav,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''FavState { status: $status, hasReachedMax: $hasReachedMax, favs: ${fav.length} }''';
  }

  @override
  List<Object> get props => [status, fav, hasReachedMax];
}
