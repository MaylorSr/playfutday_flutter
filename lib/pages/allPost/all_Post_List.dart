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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FutureBuilder<Image>(
                    future: postService.getImage('${post.authorFile}')
                        as Future<Image>,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          width: 40,
                          height: 40,
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
                  visible: post.author == user.username,
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
                                      onPressed: () => onDeletePressed(
                                          {'$user.id'} as String,
                                          post.id as int)),
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
                  child: FutureBuilder<Image>(
                    future:
                        postService.getImage('${post.image}') as Future<Image>,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image(
                          image: snapshot.data!.image,
                          fit: BoxFit.cover,
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
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
