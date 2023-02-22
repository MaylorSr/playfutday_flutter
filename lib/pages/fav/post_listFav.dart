// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/repositories/post_repositories/post_repository.dart';

import '../../services/authentication_service.dart';

class PostListItemFav extends StatelessWidget {
  const PostListItemFav({
    Key? key,
    required this.post,
    required this.postRepository,
    required User user,
  }) : super(key: key);

  final MyFavPost post;
  final PostRepository postRepository;
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
                  visible: '${post.author}' != '${'user'}',
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
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.favorite_border,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 8),
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
                      )
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
