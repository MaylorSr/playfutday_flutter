import 'package:equatable/equatable.dart';
import 'package:playfutday_flutter/blocs/export.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostFetched extends PostEvent {}

class PostFailure extends PostState {
  final String error;

  // ignore: prefer_const_constructors_in_immutables
  PostFailure({required this.error});

  @override
  List<Object> get props => [error];
}
