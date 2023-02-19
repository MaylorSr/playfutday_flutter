// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/repositories/post_repositories/search_repository.dart';

import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  final _searchRepositories = SearchRepositories();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(_searchRepositories),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
            ),
            onSubmitted: (value) {
              context.read<SearchBloc>().add(PerformSearch(value));
            },
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchLoaded) {
              final repositories = state.repositories;
              return repositories.isNotEmpty
                  ? ListView.builder(
                      itemCount: repositories.length,
                      itemBuilder: (context, index) {
                        final repository = repositories[index];
                        return ListTile(
                          title: Text('${repository.author}'),
                          onTap: () {
                            // Navigate to repository details page
                          },
                        );
                      },
                    )
                  : Center(child: Text('No results'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
