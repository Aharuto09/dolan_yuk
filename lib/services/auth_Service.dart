import 'dart:convert';

import 'package:dolan_yuk/data/data.dart';
import 'package:dolan_yuk/models/login.dart';
import 'package:dolan_yuk/models/user.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static String authUrl = '${API}/auth';
  static Future<http.Response> login(Login login) async {
    var url = '$authUrl/login';
    var body = json.encode(login.toJson);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }

  static Future<http.Response> register(User user) async {
    var url = '$authUrl/register';
    var body = json.encode(user.toJson);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }
}
