// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/repositories/post_repositories/search_repository.dart';

import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';

class SearchScreen extends StatefulWidget {
  final SearchRepositories searchRepository;

  SearchScreen({required this.searchRepository});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(widget.searchRepository);
    _searchController.addListener(() {
      final query = _searchController.text;
      if (query.isNotEmpty) {
        _searchBloc.add(SearchQueryChanged(query));
      }
    });
  }

  @override
  void dispose() {
    _searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
          ),
          onSubmitted: (query) {
            _searchBloc.add(SearchQueryChanged(query));
          },
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        bloc: _searchBloc,
        builder: (context, state) {
          if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            final results = state.results;
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text('${result.author}'),
                  /*
                  subtitle: Text('${result.description}'),*/
                  onTap: () {
                    // Navigate to details screen for result
                  },
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
