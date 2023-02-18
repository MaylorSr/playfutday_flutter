// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';

class PostListItem extends StatelessWidget {
  PostListItem({super.key, required this.post});
  /*'${post.tag}'*/
  int _likes = 0;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: new EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://source.unsplash.com/random',
              ),
            ),
            title: Text('${post.author}'),
          ),
          Container(
          
            color: Color.fromARGB(255, 11, 87, 150),
            margin: new EdgeInsets.symmetric(horizontal: 10.0),
            constraints: BoxConstraints(
              maxHeight: 480, // Tamaño máximo de la imagen
              minHeight: 380, // Tamaño mínimo de la imagen
            ),
            child: Image.network(
              '${post.image}',
              fit:
                  BoxFit.cover, // Escala la imagen para ajustarse al contenedor
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('widget.caption'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.favorite),
                  color: _likes > 0 ? Colors.red : null,
                  onPressed: () {
                    /*
                    setState(() {
                      _likes++;
                    });*/
                  },
                ),
              ),
              Expanded(
                child: Text('${post.countLikes}'),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Abrir la pantalla de comentarios aquí
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
