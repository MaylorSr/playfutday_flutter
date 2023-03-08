// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

/*
class LikeButton extends StatefulWidget {
  const LikeButton({Key? key, required this.idPost}) : super(key: key);
  final int idPost;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  final _postRepository = PostRepository();
  final int idPost = 1;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _postRepository.postLikeByMe(widget.idPost);
          _isLiked = !_isLiked;
        });
      },
      child: Icon(
        _isLiked ? Icons.favorite_border : Icons.favorite,
        color: _isLiked ? null : Colors.red,
      ),
    );
  }
}*/

class AllPostListItem extends StatelessWidget {
  final User user;
  const AllPostListItem({
    Key? key,
    required this.post,
    required this.postService,
    required this.user,
    required this.onDeletePressed,
  }) : super(key: key);

  final Post post;
  final PostService postService;
  final void Function(String, int) onDeletePressed;

  // ignore: prefer_typing_uninitialized_variables

  @override
  Widget build(BuildContext context) {
    var urlBase = "http://localhost:8080/download/";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage('$urlBase${post.authorFile}'),
                        onError: (exception, stackTrace) {
                          Image.network(
                              'https://static.vecteezy.com/system/resources/previews/004/141/669/non_2x/no-photo-or-blank-image-icon-loading-images-or-missing-image-mark-image-not-available-or-image-coming-soon-sign-simple-nature-silhouette-in-frame-isolated-illustration-vector.jpg');
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${post.author}',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Visibility(
                  visible: user.roles!.contains('ADMIN') || post.author == user.username,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "WARNING!",
                                  // ignore: prefer_const_constructors
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                    "Are you sure you want to delete this post?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                      child: Text("Delete"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        onDeletePressed('${user.id}', post.id!);
                                      }),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag:
                        'image${post.id}', // un identificador único para cada imagen
                    child: Container(
                      width: double.infinity, // ocupa todo el ancho disponible
                      height:
                          400, // altura fija para mantener la proporción de la imagen
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              // ignore: unnecessary_brace_in_string_interps
                              '${urlBase}${post.image}'), // la URL de la imagen
                          fit: BoxFit.contain,
                          onError: (exception, stackTrace) {
                            Image.network(
                                'https://cdn-icons-png.flaticon.com/512/1179/1179237.png');
                          }, // rellena el contenedor sin deformar la imagen
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 8,
                        width: 8,
                      ),
                      Text(
                        '${post.tag}',
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400),
                      ),
                      /*
                      LikeButton(
                        idPost: int.parse('${post.id}'),
                      ),*/
                      SizedBox(width: 16)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
