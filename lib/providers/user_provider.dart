import 'package:dolan_yuk/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User currentUser;
  UserProvider(
      {this.currentUser =
          const User(username: "", email: "", password: "", url: "")});

  void changeUser({required User user}) async {
    currentUser = user;
    notifyListeners();
  }

  void changeDetails({required String name, required String url}) async {
    currentUser = User(
        username: name,
        email: currentUser.email,
        password: currentUser.password,
        url: url);
    notifyListeners();
  }
}
