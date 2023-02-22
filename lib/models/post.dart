class PostResponse {
  late final List<Post> content;
  late final int totalPages;
  PostResponse({required this.content, required this.totalPages});

  PostResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Post>[];
      json['content'].forEach((v) {
        // ignore: unnecessary_new
        content!.add(new Post.fromJson(v));
      });
      totalPages = json['totalPages'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;

    return data;
  }
}

class Post {
  int? id;
  String? tag;
  String? description;
  String? image;
  String? uploadDate;
  String? author;
  String? idAuthor;
  String? authorFile;
  List<String>? likesByAuthor;
  int? countLikes;
  List<Commentaries>? commentaries;

  Post(
      {this.id,
      this.tag,
      this.description,
      this.image,
      this.uploadDate,
      this.author,
      this.idAuthor,
      this.authorFile,
      this.likesByAuthor,
      this.countLikes,
      this.commentaries});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    description = json['description'];
    image = json['image'];
    uploadDate = json['uploadDate'];
    author = json['author'];
    idAuthor = json['idAuthor'];
    authorFile = json['authorFile'];
    likesByAuthor = json['likesByAuthor'];
    countLikes = json['countLikes'];

    if (json['commentaries'] != null) {
      commentaries = <Commentaries>[];
      json['commentaries'].forEach((v) {
        commentaries!.add(new Commentaries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;
    data['description'] = this.description;
    data['image'] = this.image;
    data['uploadDate'] = this.uploadDate;
    data['author'] = this.author;
    data['idAuthor'] = this.idAuthor;
    data['authorFile'] = this.authorFile;
    data['likesByAuthor'] = this.likesByAuthor;
    data['countLikes'] = countLikes;
    if (this.commentaries != null) {
      data['commentaries'] = this.commentaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commentaries {
  String? message;
  String? authorName;
  String? uploadCommentary;

  Commentaries(int? id, {this.message, this.authorName, this.uploadCommentary});

  Commentaries.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    authorName = json['authorName'];
    uploadCommentary = json['uploadCommentary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['authorName'] = this.authorName;
    data['uploadCommentary'] = this.uploadCommentary;
    return data;
  }
}
