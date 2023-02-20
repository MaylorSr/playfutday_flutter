// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:ffi';

import 'package:flutter/material.dart';
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

  final bool _isLiked = false;

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
                  visible: '${post.author}' != '${'user.username'}',
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        '...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                        onTap: () {},
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
