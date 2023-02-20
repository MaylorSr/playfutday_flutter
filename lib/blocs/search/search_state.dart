import 'package:playfutday_flutter/models/models.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Post> results;

  SearchLoaded(this.results);
}