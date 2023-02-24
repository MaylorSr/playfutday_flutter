// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../models/user.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  final PostRepository postRepository;
  final AdminRepository adminRepository;

  const ProfileScreen(
      {Key? key,
      required this.user,
      required this.postRepository,
      required this.adminRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '@${user.username}',
          // ignore: prefer_const_constructors
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Text('Unsubscribe',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "WARNING!",
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    content: Text("Are you sure you want to unsubscribe?"),
                    actions: [
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text("Unsubscribe"),
                        onPressed: () {
                          adminRepository.deleteUserOrMe('${user.id}');
                          Future.delayed(Duration(seconds: 5), () {
                            authBloc.add(UserLoggedOut());
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<Image>(
                      future: postRepository.getImage('${user.avatar}'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CircleAvatar(
                            radius: 40.0,
                            backgroundImage: snapshot.data!.image,
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      '${user.username}',
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Text(
              '${user.biography ?? ''}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Email - ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(Icons.mail, color: Colors.grey),
                  SizedBox(width: 5.0),
                  Text(
                    '${user.email ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    'Phone - ',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                  Icon(Icons.phone, color: Colors.grey),
                  SizedBox(width: 5.0),
                  Text(
                    '${user.phone ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Text(
              '${user.birthday ?? ''}',
              style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
          ),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () {
              authBloc.add(UserLoggedOut());
            },
          ),
          Divider(),
          Expanded(
            child: user.myPost != null
                ? GridView.count(
                    mainAxisSpacing: 20,
                    crossAxisCount: 3,
                    children: List.generate(user.myPost!.length, (index) {
                      final post = user.myPost![index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // reduce el radio de borde para hacer que se vean cuadrados
                        child: FutureBuilder<Image>(
                          future: postRepository.getImage('${post.image}'),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                width:
                                    100, // establece un ancho fijo para que todos los posts tengan el mismo tamaño
                                height:
                                    100, // establece una altura fija para que todos los posts tengan el mismo tamaño
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: snapshot.data!.image,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      );
                    }),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
