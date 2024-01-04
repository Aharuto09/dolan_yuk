import 'dart:io';

import 'package:dolan_yuk/components/cards/dolanDialog.dart';
import 'package:dolan_yuk/components/widgets/dolanField.dart';
import 'package:dolan_yuk/components/widgets/mainButton.dart';
import 'package:dolan_yuk/models/user.dart';
import 'package:dolan_yuk/services/auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();
  bool passvalidate = false, emailValid = true;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    repassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    repassword.addListener(() {
      setState(() {
        passvalidate = (password.text != repassword.text);
      });
    });
    email.addListener(() {
      setState(() {
        emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email.text);
        print(emailValid);
      });
    });
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sign Up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text(
                "Sebelum menikmatin fasilitas DolanYuk, bikin akun dulu yuk!"),
            const SizedBox(height: 20),
            TextField(
              controller: email,
              decoration: InputDecoration(
                label: const Text("Email"),
                errorText: (!emailValid) ? "Pastikan format email" : null,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            DolanField(
              controller: username,
              label: "Nama Lengkap",
            ),
            const SizedBox(height: 15),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                label: const Text("Password"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: repassword,
              decoration: InputDecoration(
                label: const Text("Password Ulang"),
                errorText:
                    passvalidate ? "Pastikan sama dengan password" : null,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      context.goNamed('login');
                    },
                    child: const Text("Kembali")),
                const Spacer(),
                MainButton(
                    onPressed: () {
                      // print(password.text == repassword.text);
                      setState(() {
                        passvalidate = (password.text != repassword.text);
                      });
                      _registerState();
                    },
                    title: "Sign Up")
              ],
            )
          ],
        ),
      ),
    );
  }

  _registerState() {
    if (username.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        password.text == repassword.text) {
      AuthServices.register(User(
              username: username.text,
              email: email.text,
              password: password.text,
              url: ""))
          .then((response) {
        if (response.statusCode == HttpStatus.ok) {
          showDialog(
            context: context,
            builder: (context) => DolanDialog(
              title: "Sukses!",
              content:
                  "Registrasi berhasil, silahkan kembali dan melakukan login",
              buttonText: "Ok",
              onPressed: () {
                context.goNamed('login');
              },
            ),
          );
        } else if (response.statusCode == HttpStatus.conflict) {
          print("Conflic");
        } else {
          print("Gagal ${response.body}");
        }
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => const DolanDialog(
                title: "Field Kosong",
                content: "Pastikan semua field terisi dengan benar",
                buttonText: "Baik",
              ));
    }
  }
}
