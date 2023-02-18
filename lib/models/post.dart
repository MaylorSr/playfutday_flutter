class PostResponse {
  List<Post>? content;

  PostResponse({this.content});

  PostResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Post>[];
      json['content'].forEach((v) {
        // ignore: unnecessary_new
        content!.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
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
  String? authorFile;
  int? countLikes;
  List<Commentaries>? commentaries;

  Post(
      {this.id,
      this.tag,
      this.description,
      this.image,
      this.uploadDate,
      this.author,
      this.authorFile,
      this.countLikes,
      this.commentaries});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    description = json['description'];
    image = json['image'];
    uploadDate = json['uploadDate'];
    author = json['author'];
    authorFile = json['authorFile'];
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
    data['authorFile'] = this.authorFile;
    data['countLikes'] = this.countLikes;
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

  Commentaries({this.message, this.authorName, this.uploadCommentary});

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
