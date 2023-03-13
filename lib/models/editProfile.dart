// ignore_for_file: file_names, unnecessary_this

class EditProfileResponse {
  String? biography;
  String? birthday;
  String? phone;
  EditProfileResponse({this.biography, this.birthday, this.phone});

  EditProfileResponse.fromJson(Map<String, dynamic> json) {
    biography = json['biography'];
    birthday = json['birthday'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['biography'] = this.biography;
    data['birthday'] = this.birthday;
    data['phone'] = this.phone;
    return data;
  }
}
