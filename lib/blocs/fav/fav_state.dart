import 'package:equatable/equatable.dart';

import 'fav_event.dart';

abstract class FavEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FavFetched extends FavEvent {}

class FavFailure extends FavState {
  final String error;

  // ignore: prefer_const_constructors_in_immutables
  FavFailure({required this.error});

  @override
  List<Object> get props => [error];
}
