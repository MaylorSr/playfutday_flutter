// ignore_for_file: override_on_non_overriding_member

import 'package:bloc/bloc.dart';
import 'package:playfutday_flutter/blocs/search/search_state.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/search_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this.searchRepositories) : super(SearchInitial());

  final SearchRepositories searchRepositories;
  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    // ignore: unnecessary_type_check
    if (event is SearchEvent) {
      yield SearchLoading();
      final repositories =
          await searchRepositories.searchRepositories(event.query);
      yield SearchLoaded(repositories: repositories);
    }
  }
}
