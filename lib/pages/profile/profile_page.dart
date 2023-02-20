// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:playfutday_flutter/blocs/export.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

import '../../config/locator.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  final PostRepository postRepository;

  const ProfileScreen(
      {Key? key, required this.user, required this.postRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: FutureBuilder<Image>(
                  future: postRepository.getImage('${user.avatar}'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          backgroundImage: snapshot.data!.image,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      // ignore: prefer_const_constructors
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        // ignore: prefer_const_constructors
        SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            '@${user.username}',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        if (user.biography != null) ...[
          // ignore: prefer_const_constructors
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 25.0),
            child: Text(
              '${user.biography}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
        if (user.email != null) ...[
          // ignore: prefer_const_constructors
          SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 25.0),
            child: Text(
              '${user.biography}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
        SizedBox(height: 8.0),
        ElevatedButton(
          child: Text('Editar perfil'),
          onPressed: () {},
        ),
        Divider(),
      ],
    );
  }
}
