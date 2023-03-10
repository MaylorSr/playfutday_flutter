import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/models/favPost.dart';

enum FavStatus { initial, success, failure }

class FavState extends Equatable {
  const FavState({
    this.status = FavStatus.initial,
    this.favPosts = const <MyFavPost>[],
    this.hasReachedMax = false,
  });

  final FavStatus status;
  final List<MyFavPost> favPosts;
  final bool hasReachedMax;

  FavState copyWith({
    FavStatus? status,
    List<MyFavPost>? favPosts,
    bool? hasReachedMax,
  }) {
    return FavState(
      status: status ?? this.status,
      favPosts: favPosts ?? this.favPosts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostFavouritesState { status: $status, hasReachedMax: $hasReachedMax, posts: ${favPosts.length} }''';
  }

  @override
  List<Object> get props => [status, favPosts, hasReachedMax];
}
