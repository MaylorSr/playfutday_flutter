// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({
    super.key,
    required this.user,
  });

  final User user;

  @override
  // ignore: library_private_types_in_public_api
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  // ignore: non_constant_identifier_names
  String url_base = "http://localhost:8080/download/";

  bool _isGridView = true; // variable para cambiar la vista entre grid y lista

  List<Widget> _buildGridTiles() {
    // lista de widgets para la vista de grid
    return List.generate(
      widget.user.myPost!.length,
      (index) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        margin: EdgeInsets.all(5),
        child: Image.network(
          '${url_base}${widget.user.myPost![index].image}',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  List<Widget> _buildListTiles() {
    // lista de widgets para la vista de lista
    return List.generate(
      widget.user.myPost!.length,
      (index) => ListBody(
        children: [
          Padding(
              padding: EdgeInsets.all(28.0),
              child: Image.network(
                '${url_base}${widget.user.myPost![index].image}',
                fit: BoxFit.contain,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      ),
                    ),
                    Text(
                      'MyPosts',
                      style: TextStyle(
                        color: Colors.grey,
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
                      ),
                    ),
                    Text(
                      'Favs',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            )),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
            ),
            SizedBox(width: 16),
          ],
        ),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsetsDirectional.only(start: 22),
          child: Column(children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text('@${widget.user.username}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 10),
                Text('${widget.user.email}'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 10),
                Text('${widget.user.phone}'),
              ],
            ),
            Row(
              children: [
                widget.user.birthday == null
                    ? SizedBox()
                    : Icon(Icons.calendar_month),
                SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Text('${widget.user.birthday ?? ''}'),
              ],
            ),
            Row(
              children: [
                widget.user.biography == null
                    ? SizedBox()
                    : Icon(Icons.message_rounded),
                SizedBox(width: 10),
                // ignore: unnecessary_string_interpolations
                Text('${widget.user.biography ?? ''}'),
              ],
            )
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
                    color: _isGridView ? Colors.black : Colors.grey,
                    onPressed: () => setState(() => _isGridView = true),
                  ),
                  IconButton(
                    icon: Icon(Icons.list),
                    color: !_isGridView ? Colors.black : Colors.grey,
                    onPressed: () => setState(() => _isGridView = false),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    color: !_isGridView ? Colors.black : Colors.grey,
                    onPressed: () => setState(() => _isGridView = false),
                  )
                ],
              ),
              // vista de grid o lista según la variable _isGridView
              Expanded(
                child: _isGridView
                    ? GridView.count(
                        crossAxisCount: 2,
                        children: _buildGridTiles(),
                      )
                    : ListView(
                        children: _buildListTiles(),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
