class UserLogin {
  String? id;
  String? username;
  String? createdAt;
  String? email;
  String? avatar;
  String? biography;
  String? phone;
  String? birthday;
  bool? enabled;
  List<MyPost>? myPost;
  List<String>? roles;
  String? token;

  UserLogin(
      {this.id,
      this.username,
      this.createdAt,
      this.email,
      this.avatar,
      this.phone,
      this.birthday,
      this.enabled,
      this.myPost,
      this.roles,
      this.token});

  UserLogin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    createdAt = json['createdAt'];
    email = json['email'];
    avatar = json['avatar'];
    biography = json['biography'];
    phone = json['phone'];
    birthday = json['birthday'];
    enabled = json['enabled'];
    if (json['myPost'] != null) {
      myPost = <MyPost>[];
      json['myPost'].forEach((v) {
        myPost!.add(new MyPost.fromJson(v));
      });
    }
    roles = json['roles'].cast<String>();
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['createdAt'] = this.createdAt;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['biography'] = this.biography;

    data['phone'] = this.phone;
    data['birthday'] = this.birthday;
    data['enabled'] = this.enabled;
    if (this.myPost != null) {
      data['myPost'] = this.myPost!.map((v) => v.toJson()).toList();
    }
    data['roles'] = this.roles;
    data['token'] = this.token;
    return data;
  }
}

class MyPost {
  int? id;
  String? tag;
  String? image;
  String? uploadDate;
  String? author;
  String? authorFile;
  int? countLikes;
  List<Commentaries>? commentaries;

  MyPost(
      {this.id,
      this.tag,
      this.image,
      this.uploadDate,
      this.author,
      this.authorFile,
      this.countLikes,
      this.commentaries});

  MyPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
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
  int? id;
  String? message;
  String? authorName;
  String? uploadCommentary;

  Commentaries({this.id, this.message, this.authorName, this.uploadCommentary});

  Commentaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    authorName = json['authorName'];
    uploadCommentary = json['uploadCommentary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['authorName'] = this.authorName;
    data['uploadCommentary'] = this.uploadCommentary;
    return data;
  }
}
