import 'dart:convert';
import 'dart:io';

import 'package:dolan_yuk/components/cards/dolanDialog.dart';
import 'package:dolan_yuk/components/widgets/dolanField.dart';
import 'package:dolan_yuk/components/widgets/mainButton.dart';
import 'package:dolan_yuk/components/widgets/secondaryButton.dart';
import 'package:dolan_yuk/models/dolan.dart';
import 'package:dolan_yuk/models/login.dart';
import 'package:dolan_yuk/models/user.dart';
import 'package:dolan_yuk/providers/dolan_provider.dart';
import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:dolan_yuk/services/auth_Service.dart';
import 'package:dolan_yuk/services/schedule_Service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              const Text("DolanYuk",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              DolanField(
                controller: _email,
                label: "Email",
              ),
              const SizedBox(height: 20),
              DolanField(
                controller: _pass,
                label: "Password",
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    onPressed: () {
                      context.goNamed('register');
                    },
                    title: "Sign Up",
                  ),
                  const SizedBox(width: 10),
                  MainButton(
                    onPressed: _loginState,
                    title: "Sign In",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _loginState() {
    if (_email.text.isNotEmpty && _pass.text.isNotEmpty) {
      AuthServices.login(Login(email: _email.text, password: _pass.text))
          .then((response) {
        if (response.statusCode == HttpStatus.ok) {
          final data = response.body;
          final result = jsonDecode(data);
          ScheduleService.getDolan().then((value) {
            context.read<DolanProvider>().clearDolan();
            Map<String, dynamic> dolans = jsonDecode(value.body);
            for (var item in dolans.entries) {
              // print(item.key.runtimeType);
              context.read<DolanProvider>().addDolan(Dolan(
                  id: int.parse(item.key),
                  name: item.value["name"],
                  min: item.value["min_member"] as int));
            }
            context.read<UserProvider>().changeUser(
                user: User(
                    id: result["id"] ?? 0,
                    username: result["name"],
                    email: result["email"],
                    password: result["pass"],
                    url: (result["url"] != "null") ? result["url"] : ""));

            context.goNamed(
              'main',
            );
          });
        } else {
          showDialog(
              context: context,
              builder: (context) => DolanDialog(
                  title: "Gagal",
                  content: "Pastikan email dan kata sandi sudah benar",
                  buttonText: "Mengerti!"));
        }
      });
    }
  }
}
