// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

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
        _isLiked ? Icons.favorite : Icons.favorite_border,
        color: _isLiked ? Colors.red : null,
      ),
    );
  }
}

class PostListItem extends StatelessWidget {
  final User user;
  const PostListItem({
    Key? key,
    required this.post,
    required this.postRepository,
    required this.user,
  }) : super(key: key);

  final Post post;
  final PostRepository postRepository;

  // ignore: unused_field
  final bool _isLiked = false;
  // ignore: no_leading_underscores_for_local_identifiers, unused_element

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
                    future: postRepository.getImage('${post.authorFile}'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
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
                    visible: user.roles?.contains('ADMIN') ?? false || user.username == post.author,
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
                                      postRepository.deletePostByAdmin(
                                          post.id as int,
                                          post.idAuthor as String);
                                      // Aquí iría el código para eliminar la publicación
                                      Navigator.pop(context);
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
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FutureBuilder<Image>(
                    future: postRepository.getImage('${post.image}'),
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
            if (post.description != null)
              Container(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 5.0, left: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 3),
                          Text(
                            '${post.author}: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${post.description}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                      SizedBox(width: 8),
                      LikeButton(
                        idPost: int.parse('${post.id}'),
                      ),
                      SizedBox(width: 3),
                      SizedBox(width: 3),
                      Text(
                        '${post.countLikes}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentDialog(
                                  post: post, postRepository: PostRepository()),
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
                        '${post.commentaries == null ? 0 : post.commentaries!.length} ',
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
  final PostRepository postRepository;

  const CommentDialog({required this.post, required this.postRepository});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  final postRepository = PostRepository();
  _addComment(_commentController, int idPost) {
    postRepository.sendCommentaries(_commentController, idPost);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Image>(
          future: postRepository.getImage('${widget.post.image}'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image(
                image: snapshot.data!.image,
                width: 600,
                height: 800,
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
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
                      _addComment(_commentController.text,
                          int.parse('${widget.post.id}'));
                      _commentController.clear();
                      Navigator.pop(context);
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
