// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/pages/post/post_page.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';
import '../models/models.dart';
import '../models/user.dart';


/*
class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
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
      final postService = PostService();

      body: BlocProvider(
        create: (_) => PostBloc(postService: postService)..add(PostFetched()),
        child: const PostList(),
      ),

      /*SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Welcome, ${user.username}',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                //textColor: Theme.of(context).primaryColor,
                /*style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),*/
                child: Text('Logout'),
                onPressed: () {
                  authBloc.add(UserLoggedOut());
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    print("Check");
                    JwtAuthenticationService service =
                        getIt<JwtAuthenticationService>();
                    await service.getCurrentUser();
                  },
                  child: Text('Check'))
            ],
          ),
        ),*/
    );
  }
}*/

class HomePage extends StatelessWidget {
  final User user;
  final PostRepository postRepository;
  const HomePage({super.key, required this.user, required this.postRepository});

  @override
  Widget build(BuildContext context) {
    // move the line here
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

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
        create: (_) => PostBloc(postRepository)..add(PostFetched()),
        child: const PostList(),
      ),
    );
  }
}
