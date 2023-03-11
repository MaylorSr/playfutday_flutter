// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

import '../../models/favPost.dart';

class PostListItemFav extends StatefulWidget {
  final User user;
  const PostListItemFav({
    Key? key,
    required this.post,
    required this.postService,
    required this.user,
    required this.onDeletePressed,
    required this.onSendLikedPressed,
  }) : super(key: key);

  final MyFavPost post;
  final PostService postService;
  final void Function(String, int) onDeletePressed;
  final void Function(int) onSendLikedPressed;

  @override
  _PostListItemFavState createState() => _PostListItemFavState();
}

class _PostListItemFavState extends State<PostListItemFav> {
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked = true;
    _likesCount = widget.post.countLikes!;
  }

  @override
  Widget build(BuildContext context) {
    var urlBase = "http://localhost:8080/download/";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: Colors.black,
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(
                        horizontal: 8, vertical: 8),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            NetworkImage('$urlBase${widget.post.authorFile}'),
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
                    '${widget.post.author}',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Visibility(
                  visible: widget.post.author == widget.user.username,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  "WARNING!",
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
                                        widget.onDeletePressed(
                                            '${widget.user.id}',
                                            widget.post.id!);
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
                    tag: 'image${widget.post.id}',
                    child: Container(
                      width: double.infinity, // ocupa todo el ancho disponible
                      height:
                          400, // altura fija para mantener la proporción de la imagen
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              // ignore: unnecessary_brace_in_string_interps
                              '${urlBase}${widget.post.image}'), // la URL de la imagen
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
                        '${widget.post.tag}',
                        style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLiked = !_isLiked;
                                if (_isLiked) {
                                  _likesCount++;
                                } else {
                                  _likesCount--;
                                }
                              });
                              widget.onSendLikedPressed(
                                  int.parse('${widget.post.id}'));
                            },
                          ),
                          Text(
                            '$_likesCount',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ],
                      ),
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
