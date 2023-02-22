// ignore: file_names
class PostFavResponse {
  List<MyFavPost>? content;
  late final int totalPages;

  PostFavResponse({this.content});

  PostFavResponse.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <MyFavPost>[];
      json['content'].forEach((v) {
        content!.add(new MyFavPost.fromJson(v));
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

class MyFavPost {
  String? tag;
  String? image;
  String? author;
  String? authorFile;
  int? countLikes;

  MyFavPost(
      {this.tag, this.image, this.author, this.authorFile, this.countLikes});

  MyFavPost.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    image = json['image'];
    author = json['author'];
    authorFile = json['authorFile'];
    countLikes = json['countLikes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['image'] = this.image;
    data['author'] = this.author;
    data['authorFile'] = this.authorFile;
    data['countLikes'] = this.countLikes;
    return data;
  }
}
