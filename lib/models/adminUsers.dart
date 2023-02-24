// ignore_for_file: unnecessary_new, unnecessary_this

class UserResponseAdmin {
  List<InfoUser>? content;
  int? totalPages;

  UserResponseAdmin({this.content, this.totalPages});

  UserResponseAdmin.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <InfoUser>[];
      json['content'].forEach((v) {
        content!.add(new InfoUser.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
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

class InfoUser {
  String? id;
  String? username;
  String? createdAt;
  String? avatar;
  String? biography;
  String? birthday;
  bool? enabled;
  List<String>? roles;
  List<MyPost>? myPost;

  InfoUser(
      {this.id,
      this.username,
      this.createdAt,
      this.avatar,
      this.biography,
      this.birthday,
      this.enabled,
      this.roles,
      this.myPost});

  InfoUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    createdAt = json['createdAt'];
    avatar = json['avatar'];
    biography = json['biography'];
    birthday = json['birthday'];
    enabled = json['enabled'];
    roles = json['roles'].cast<String>();
    if (json['myPost'] != null) {
      myPost = <MyPost>[];
      json['myPost'].forEach((v) {
        myPost!.add(new MyPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['createdAt'] = this.createdAt;
    data['avatar'] = this.avatar;
    data['biography'] = this.biography;
    data['birthday'] = this.birthday;
    data['enabled'] = this.enabled;
    data['roles'] = this.roles;
    if (this.myPost != null) {
      // ignore: unnecessary_this
      data['myPost'] = this.myPost!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPost {
  MyPost();

  // ignore: empty_constructor_bodies
  MyPost.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
