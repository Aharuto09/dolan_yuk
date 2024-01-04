import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/data.dart';
import '../models/user.dart';

class UserService {
  static String Url = '${API}/user';
  static Future<http.Response> update(User data) async {
    var url = '$Url/';
    var body = json.encode(data.forUpdate);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    return response;
  }
}
