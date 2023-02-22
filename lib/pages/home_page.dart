// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/pages/post/post_page.dart';
import 'package:playfutday_flutter/pages/profile/profile_page.dart';
import 'package:playfutday_flutter/pages/search/search_page.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/search_repository.dart';
import '../blocs/bottonNavigator/bottom_navigation_bloc.dart';
import '../blocs/fav/fav_bloc.dart';
import '../blocs/fav/fav_event.dart';
import '../blocs/fav/fav_state.dart';
import '../blocs/photo/photo_bloc.dart';
import '../blocs/photo/route/generate_route.dart';
import '../blocs/photo/route/route_nanme.dart';
import '../models/models.dart';
import '../models/user.dart';
import 'fav/post_pageFav.dart';
import 'login_page.dart';
import 'myPost/myPost_page.dart';

class HomePage extends StatefulWidget {
  final PostRepository postRepository;
  final SearchRepositories searchRepositories;
  final User user;

  const HomePage(
      {required this.postRepository,
      required this.searchRepositories,
      required this.user});
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BottomNavigationBloc _bottomNavigationBloc;
  int _selectedIndex = 0;

  @override
  void initState() {
    _bottomNavigationBloc = BottomNavigationBloc();
    super.initState();
  }

  @override
  void dispose() {
    _bottomNavigationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: _selectedIndex == 0
                    ? Color.fromARGB(255, 0, 153, 255)
                    : Colors.grey),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 135, 7, 255),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _selectedIndex == 1
                      ? Color.fromARGB(255, 0, 153, 255)
                      : Colors.grey),
              label: 'Search',
              backgroundColor: Color.fromARGB(255, 135, 7, 255)),
          BottomNavigationBarItem(
              icon: Icon(Icons.add,
                  color: _selectedIndex == 2
                      ? Color.fromARGB(255, 0, 153, 255)
                      : Colors.grey),
              label: '',
              backgroundColor: Color.fromARGB(255, 135, 7, 255)),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _selectedIndex == 3
                      ? Color.fromARGB(255, 0, 153, 255)
                      : Colors.grey),
              label: 'Fav',
              backgroundColor: Color.fromARGB(255, 135, 7, 255)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _selectedIndex == 4
                      ? Color.fromARGB(255, 0, 153, 255)
                      : Colors.grey),
              label: 'Profile',
              backgroundColor: Color.fromARGB(255, 135, 7, 255)),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _bottomNavigationBloc.setIndex(index);
        },
      ),
      body: StreamBuilder<int>(
        stream: _bottomNavigationBloc.indexStream,
        initialData: 0,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case 0:
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: Text('PlayFutDay',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                  body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state is AuthenticationAuthenticated) {
                        return BlocProvider(
                            create: (_) => PostBloc(widget.postRepository)
                              ..add(PostFetched()),
                            child: PostList(
                              user: state.user,
                            ));
                      } else {
                        return LoginPage();
                      }
                    },
                  ));
            case 1:
              return SearchScreen(
                searchRepository: widget.searchRepositories,
              );
            case 2:
              return BlocProvider(
                create: (_) => PhotoBloc(),
                child: MaterialApp(
                  initialRoute: routeHome,
                  onGenerateRoute: RouteGenerator.generateRoute,
                ),
              );
            case 3:
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    title: Text('PlayFutDay',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                  body: BlocProvider(
                    create: (_) =>
                        FavBloc(widget.postRepository)..add(FavFetched()),
                    child: PostListFav(),
                  ));
            case 4:
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return ProfileScreen(
                      user: state.user,
                      postRepository: PostRepository(),
                    );
                  } else {
                    return LoginPage();
                  }
                },
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
