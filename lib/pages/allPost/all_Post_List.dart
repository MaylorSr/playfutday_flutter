// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, non_constant_identifier_names, unnecessary_overrides

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key, required this.idPost, required this.onSendLikePressed})
      : super(key: key);
  final int idPost;
  final void Function(int) onSendLikePressed;

  @override
  // ignore: library_private_types_in_public_api
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  final _postService = PostService();
  final int idPost = 1;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          widget.onSendLikePressed(widget.idPost);
          _postService.postLikeByMe(widget.idPost);
          _isLiked = !_isLiked;
        });
      },
      child: Icon(
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : null,
      ),
    );
  }
}

class AllPostListItem extends StatelessWidget {
  final User user;
  const AllPostListItem({
    Key? key,
    required this.post,
    required this.postService,
    required this.user,
    required this.onDeletePressed,
    required this.onSendCommentariePressed,
    required this.onSendLikePressed,
  }) : super(key: key);

  final Post post;
  final PostService postService;
  final void Function(String, int) onDeletePressed;
  final void Function(String, int) onSendCommentariePressed;
  final void Function(int) onSendLikePressed;

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
                  visible: user.roles!.contains('ADMIN') ||
                      post.author == user.username,
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
                      LikeButton(
                        idPost: int.parse('${post.id}'),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentDialog(
                                // ignore: avoid_types_as_parameter_names
                                post: post, postService: PostService(),
                                onSendCommentariePressed: (String, int) {},
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${post.commentaries == null ? '' : post.commentaries!.length} ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('${post.uploadDate}'),
            )
          ],
        ),
      ),
    );
  }
}

class CommentDialog extends StatefulWidget {
  final Post post;
  final PostService postService;
  final void Function(String, int) onSendCommentariePressed;

  // ignore: use_key_in_widget_constructors
  const CommentDialog(
      {required this.post,
      required this.postService,
      required this.onSendCommentariePressed});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  final postService = PostService();
  @override
  CommentDialog get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    var urlBase = "http://localhost:8080/download/";

    return Stack(
      children: [
        Hero(
          tag:
              'image${widget.post.id}', // un identificador único para cada imagen
          child: Container(
            width: double.infinity, // ocupa todo el ancho disponible
            height: 400, // altura fija para mantener la proporción de la imagen
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
        Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Comentaries',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.post.author}'),
              ),
              Divider(),
              if (widget.post.commentaries != null &&
                  widget.post.commentaries!.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.post.commentaries!.length,
                    itemBuilder: (context, index) {
                      final comment = widget.post.commentaries![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${comment.authorName?[0]}'),
                            ),
                            title: Text('${comment.message}'),
                            subtitle: Text('${comment.uploadCommentary}'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write your commentarie',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onSendCommentariePressed(_commentController.text,
                          int.parse('${widget.post.id}'));
                      _commentController.clear();
                    },
                    child: Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
