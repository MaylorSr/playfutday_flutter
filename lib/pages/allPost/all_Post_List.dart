
import 'package:flutter/material.dart';
import 'package:playfutday_flutter/models/models.dart';
import 'package:playfutday_flutter/services/post_service/post_service.dart';

class AllPostListItem extends StatefulWidget {
  final User user;
  final Post post;
  final PostService postService;
  final void Function(String, int) onDeletePressed;
  final void Function(String, int) onSendCommentariePressed;
  final void Function(int) onSendLikedPressed;

  const AllPostListItem({
    Key? key,
    required this.user,
    required this.post,
    required this.postService,
    required this.onDeletePressed,
    required this.onSendCommentariePressed,
    required this.onSendLikedPressed,
  }) : super(key: key);

  @override
  _AllPostListItemState createState() => _AllPostListItemState();
}

class _AllPostListItemState extends State<AllPostListItem> {
  late bool _isLiked;
  late int _likesCount;

  @override
  void initState() {
    super.initState();
    _isLiked =
        widget.post.likesByAuthor?.contains(widget.user.username) ?? false;
    _likesCount = widget.post.countLikes!;
  }

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
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 10),
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.user.roles!.contains('ADMIN') ||
                      widget.post.author == widget.user.username,
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
                    tag:
                        'image${widget.post.id}', // un identificador único para cada imagen
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
                            fontWeight: FontWeight.w400),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : null,
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
                          Text('$_likesCount'),
                        ],
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentDialog(
                                post: widget.post,
                                postService: PostService(),
                                onSendCommentariePressed:
                                    widget.onSendCommentariePressed,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${widget.post.commentaries == null ? '0' : widget.post.commentaries!.length.toString()}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('${widget.post.uploadDate}'),
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

  const CommentDialog({
    Key? key,
    required this.post,
    required this.postService,
    required this.onSendCommentariePressed,
  }) : super(key: key);

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommentEmpty = true;

  void _addComment(String message, int idPost) {
    widget.onSendCommentariePressed(message, idPost);
  }

  void _onCommentChanged(String value) {
    setState(() {
      _isCommentEmpty = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: widget.post.commentaries?.length ?? 0,
              itemBuilder: (context, index) {
                final commentary = widget.post.commentaries![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      '${commentary.authorName?[0]}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    commentary.message!,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commentary.authorName ?? '',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        commentary.uploadCommentary.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: _onCommentChanged,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isCommentEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _addComment(_commentController.text,
                              int.parse('${widget.post.id}'));
                          _commentController.clear();
                        },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
