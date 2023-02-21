class RegisterRequest {
  String? username;
  String? password;
  String? veryfyPassword;
  String? email;
  String? phone;

  RegisterRequest(
      {this.username,
      this.password,
      this.veryfyPassword,
      this.email,
      this.phone});

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    veryfyPassword = json['veryfyPassword'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['veryfyPassword'] = veryfyPassword;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
