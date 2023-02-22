class PostFav {
  List<Content>? content;
  late final int totalPages;

  PostFav({this.content});

  PostFav.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
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

class Content {
  String? tag;
  String? image;
  String? author;
  String? authorFile;
  int? countLikes;

  Content(
      {this.tag, this.image, this.author, this.authorFile, this.countLikes});

  Content.fromJson(Map<String, dynamic> json) {
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
