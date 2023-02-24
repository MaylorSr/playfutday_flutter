// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/repositories/admin_repositories/admin_repository.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

import '../../models/adminUsers.dart';

class DetailsUser extends StatefulWidget {
  const DetailsUser({
    super.key,
    required this.details,
    required this.postRepository,
  });

  final InfoUser details;
  final PostRepository postRepository;

  @override
  _DetailsUserState createState() => _DetailsUserState();
}

class _DetailsUserState extends State<DetailsUser> {
  bool _isReloaded = false;

  void _reload() {
    setState(() {
      _isReloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 2, 9, 68)),
        title: Text('PlayFutDay',
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      body: (Column(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  FutureBuilder<Image>(
                    future: widget.postRepository
                        .getImage('${widget.details.avatar}'),
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
                    '${widget.details.username}',
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Text(
            '${widget.details.biography ?? ''}',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  'Birthday -',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
                Icon(Icons.cake, color: Colors.grey),
                SizedBox(width: 5.0),
                Text(
                  '${widget.details.birthday ?? ''}',
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
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 5.0),
                Text(
                  'Create -',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
                Icon(Icons.create, color: Colors.grey),
                Text(
                  '${widget.details.createdAt ?? ''}',
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
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 5.0),
                Text(
                  'Enable -',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
                Icon(Icons.accessibility, color: Colors.grey),
                Text(
                  '${widget.details.enabled ?? ''}',
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
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 5.0),
                Text(
                  'ROLE/S -',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
                Icon(Icons.person_2, color: Colors.grey),
                Text(
                  '${widget.details.roles ?? ''}',
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
          margin: EdgeInsets.symmetric(vertical: 3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(width: 5.0),
                Text(
                  'ID -',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
                Icon(Icons.perm_identity_outlined, color: Colors.grey),
                Text(
                  '${widget.details.id ?? ''}',
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
          margin: EdgeInsets.symmetric(vertical: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  AdminRepository().banUser('${widget.details.id}');
                  _reload();
                },
                child: Text('Ban user'),
              ),
              ElevatedButton(
                onPressed: () {
                  AdminRepository().changeRole('${widget.details.id}');
                  _reload();
                },
                child: Text('Add/remove role to ADMIN'),
              ),
            ],
          ),
        ),
      ])),
    );
  }
}
