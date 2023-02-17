import 'login.dart';

/*class User {
  String? id;
  String? username;
  String? avatar;
  String? fullName;

  User({this.id, this.username, this.avatar, this.fullName});

  User.fromLoginResponse(LoginResponse response) {
    this.id = response.id;
    this.username = response.username;
    this.avatar = response.avatar;
    this.fullName = response.fullName;
  }
}

class UserResponse extends User {
  UserResponse(id, username, fullName, avatar)
      : super(id: id, username: username, fullName: fullName, avatar: avatar);

  UserResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatar = json['avatar'];
    fullName = json['fullName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['fullName'] = this.fullName;
    return data;
  }
}
*/

class User {
  String? id;
  String? username;
  String? email;
  String? avatar;
  String? biography;
  String? phone;
  String? birthday;
  List<MyPost>? myPost;
  List<String>? roles;
  String? token;

  User(
      {this.id,
      this.username,
      this.email,
      this.avatar,
      this.biography,
      this.phone,
      this.birthday,
      this.myPost,
      this.roles,
      this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    avatar = json['avatar'];
    biography = json['biography'];
    phone = json['phone'];
    birthday = json['birthday'];
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
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['biography'] = this.biography;
    data['phone'] = this.phone;
    data['birthday'] = this.birthday;
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
  int? countLikes;
  List<Commentaries>? commentaries;

  MyPost(
      {this.id,
      this.tag,
      this.image,
      this.uploadDate,
      this.author,
      this.countLikes,
      this.commentaries});

  MyPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tag = json['tag'];
    image = json['image'];
    uploadDate = json['uploadDate'];
    author = json['author'];
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

class UserResponse extends User {
  UserResponse(username, avatar) : super();

  UserResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    avatar = json['avatar'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['avatar'] = avatar;
    return data;
  }
}
