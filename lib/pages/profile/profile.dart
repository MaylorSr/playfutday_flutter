// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/myPost/myPost_bloc.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/pages/profile/post_pageFav.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../blocs/allPost/allPost_event.dart';
import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/favPost/fav_Post_event.dart';
import '../../blocs/favPost/fav_post_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../myPost/post_page.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({
    super.key,
    required this.user,
    required this.postService,
  });

  final User user;
  final PostService postService;

  @override
  // ignore: library_private_types_in_public_api
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  // ignore: non_constant_identifier_names
  String url_base = "http://localhost:8080/download/";

  int _view = 1; // variable para cambiar la vista entre grid y lista

  List<Widget> _buildGridMyPost() {
    // lista de widgets para la vista de grid
    return List.generate(
      widget.user.myPost!.length,
      (index) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    '${url_base}${widget.user.myPost![index].image}'),
                onError: (exception, stackTrace) {
                  Image.network(
                      'https://img.freepik.com/vector-premium/vector-fondo-blanco-geometrico-abstracto_496885-15.jpg');
                }),
            border: Border.all(color: Colors.black),
          ),
          margin: EdgeInsets.all(5)),
    );
  }

  // ignore: unused_element
  BlocProvider _buildListMyPost() {
    // lista de widgets para la vista de lista
    return BlocProvider(
        create: (_) => MyPostBloc(widget.postService)..add(AllPostFetched()),
        child: MyPostList(
          user: widget.user,
        ));
  }

  BlocProvider _buildListMyFavPost() {
    // lista de widgets para la vista de lista
    return BlocProvider(
        create: (_) => FavBloc(widget.postService)..add(FavFetched()),
        child: PostListFav(
          user: widget.user,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Column(
      children: [
        SizedBox(height: 24),
        Row(
          children: [
            SizedBox(width: 16),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                '${url_base}${widget.user.avatar}',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.user.myPost == null ? 0 : widget.user.myPost!.length}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      'MyPosts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'FAVS',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      'Favs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            )),
            IconButton(
                onPressed: () {
                  authBloc.add(UserLoggedOut());
                },
                icon: Icon(Icons.logout),
                color: Colors.white),
            SizedBox(width: 16),
          ],
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsetsDirectional.only(start: 22),
          child: Column(children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  '@${widget.user.username}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text('${widget.user.email}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text('${widget.user.phone}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            Row(
              children: [
                widget.user.birthday == null
                    ? SizedBox()
                    : Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Text(
                  '${widget.user.birthday ?? ''}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                widget.user.biography == null
                    ? SizedBox()
                    : Icon(
                        Icons.message_rounded,
                        color: Colors.white,
                      ),
                SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Text(
                  '${widget.user.biography ?? ''}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.grey),
                      ),
                      child: Text('Edit Profile'),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
        SizedBox(height: 16),
        Divider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // botones para cambiar la vista entre grid y lista
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.grid_on),
                    color: _view == 1 ? Colors.white : Colors.grey,
                    onPressed: () => setState(() => _view = 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.list),
                    color: _view == 2 ? Colors.white : Colors.grey,
                    onPressed: () => setState(() => _view = 2),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    color: _view == 3 ? Colors.white : Colors.grey,
                    onPressed: () => setState(() => _view = 3),
                  )
                ],
              ),
              // vista de grid o lista según la variable _isGridView
              Expanded(
                child: _view == 1
                    ? GridView.count(
                        crossAxisCount: 2,
                        children: _buildGridMyPost(),
                      )
                    : _view == 2
                        ? BlocProvider(
                            create: (_) => MyPostBloc(widget.postService)
                              ..add(AllPostFetched()),
                            child: _buildListMyPost(),
                          )
                        : BlocProvider(
                            create: (_) =>
                                FavBloc(widget.postService)..add(FavFetched()),
                            child: _buildListMyFavPost(),
                          ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
