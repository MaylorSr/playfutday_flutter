import 'package:playfutday_flutter/models/register.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
String url_base = "http://localhost:8080/auth/register";

class RegisterRepository {
  Future<dynamic> doRegister(String username, String password,
      String veryfyPassword, String email, String phone) async {
    final response = await http.post(Uri.parse(url_base),
        body: RegisterRequest(
            username: username,
            password: password,
            veryfyPassword: veryfyPassword,
            email: email,
            phone: phone));
    if (response.statusCode == 201) return true;
    return response.statusCode;
  }
}
