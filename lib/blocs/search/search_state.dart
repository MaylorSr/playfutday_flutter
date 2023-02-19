import 'package:playfutday_flutter/models/models.dart';
abstract  class SearchEvent {
  final String query;

  SearchEvent({required this.query});
}
class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Post> repositories;

  SearchLoaded({required this.repositories});
}

class PerformSearch extends SearchEvent {
  final String query;
  PerformSearch(this.query) : super(query: 'messi');
}