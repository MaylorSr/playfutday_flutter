// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/blocs/profile/profile_bloc.dart';
import 'package:playfutday_flutter/blocs/profile/profile_event.dart';
import 'package:playfutday_flutter/pages/pages.dart';
import 'package:playfutday_flutter/pages/profile/view.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';
import 'package:playfutday_flutter/services/user_service/user_service.dart';
import '../blocs/bottonNavigator/bottom_navigation_bloc.dart';
import '../models/models.dart';
import '../models/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  final PostService postService;
  final UserService userService;

  const HomePage({
    super.key,
    required this.postService,
    required this.user,
    required this.userService,
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
        currentIndex:
            _selectedIndex >= 0 && _selectedIndex < 2 ? _selectedIndex : 0,
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
              icon: Icon(Icons.person,
                  color: _selectedIndex == 1
                      ? Color.fromARGB(255, 0, 153, 255)
                      : Colors.grey),
              label: 'Profile',
              backgroundColor: Color.fromARGB(255, 135, 7, 255))
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
                            create: (_) => AllPostBloc(widget.postService)
                              ..add(AllPostFetched()),
                            child: AllPostList(
                              user: state.user,
                            ));
                      } else {
                        return LoginPage();
                      }
                    },
                  ));
            case 1:
              return Scaffold(
                  body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is AuthenticationAuthenticated) {
                    return BlocProvider(
                        create: (_) => ProfileBloc(widget.userService)
                          ..add(ProfileFetched()),
                        child: ProfileUser(
                          user: state.user,
                        ));
                  } else {
                    return LoginPage();
                  }
                },
              ));

            default:
              return Container();
          }
        },
      ),
    );
  }
}
