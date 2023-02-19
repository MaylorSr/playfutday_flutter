// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/blocs/search/search_bloc.dart';
import 'package:playfutday_flutter/blocs/search/search_state.dart';
import 'package:playfutday_flutter/pages/post/post_page.dart';
import 'package:playfutday_flutter/pages/profile/profile_page.dart';
import 'package:playfutday_flutter/pages/search/search_page.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/search_repository.dart';
import 'package:playfutday_flutter/repositories/user_repository.dart';
import '../blocs/bottonNavigator/bottom_navigation_bloc.dart';
import '../models/models.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  final PostRepository postRepository;
  final UserRepository userRepository;
  final SearchRepositories searchRepositories;

  const HomePage({
    super.key,
    required this.user,
    required this.postRepository,
    required this.userRepository,
    required this.searchRepositories,
  });
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
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _selectedIndex == 1
                    ? Color.fromARGB(255, 0, 153, 255)
                    : Colors.grey),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add,
                color: _selectedIndex == 2
                    ? Color.fromARGB(255, 0, 153, 255)
                    : Colors.grey),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _selectedIndex == 3
                    ? Color.fromARGB(255, 0, 153, 255)
                    : Colors.grey),
            label: 'Fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _selectedIndex == 4
                    ? Color.fromARGB(255, 0, 153, 255)
                    : Colors.grey),
            label: 'Profile',
          ),
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
                  body: BlocProvider(
                    create: (_) =>
                        PostBloc(widget.postRepository)..add(PostFetched()),
                    child: PostList(),
                  ));
            case 1:
              return BlocProvider(
                  create: (_) => SearchBloc(widget.searchRepositories)
                    ..add(PerformSearch('messi')),
                  child: SearchPage());
            case 4:
              return Scaffold(
                  body: BlocProvider(
                      create: (_) => ProfileBloc(widget.userRepository),
                      child:
                          ProfileScreen(ProfileBloc(widget.userRepository))));

            default:
              return Container();
          }
        },
      ),
    );
  }
}
