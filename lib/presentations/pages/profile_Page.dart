import 'dart:io';

import 'package:dolan_yuk/components/cards/dolanDialog.dart';
import 'package:dolan_yuk/components/widgets/dolanField.dart';
import 'package:dolan_yuk/components/widgets/mainButton.dart';
import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:dolan_yuk/services/user_Service.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController url = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username.text = context.read<UserProvider>().currentUser.username;
    email.text = context.read<UserProvider>().currentUser.email;
    url.text = context.read<UserProvider>().currentUser.url;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(
            child: ImageNetwork(
              image: context.read<UserProvider>().currentUser.url,
              height: 120,
              width: 120,
              borderRadius: BorderRadius.circular(100),
              onLoading: const CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
              onError: const Icon(
                Icons.error,
                color: Colors.red,
              ),
              onTap: () {
                debugPrint("©gabriel_patrick_souza");
              },
            ),
          ),
          const SizedBox(height: 20),
          DolanField(controller: username, label: "Nama Lengkap"),
          const SizedBox(height: 20),
          TextField(
            controller: email,
            readOnly: true,
            decoration: const InputDecoration(
              label: Text("Email"),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          DolanField(controller: url, label: "Photo URL"),
          const SizedBox(height: 20),
          MainButton(
              onPressed: () {
                if (username.text.isNotEmpty && url.text.isNotEmpty) {
                  User temp = User(
                      id: context.read<UserProvider>().currentUser.id,
                      username: username.text,
                      email: email.text,
                      password:
                          context.read<UserProvider>().currentUser.password,
                      url: url.text);
                  // temp.username = username.text;
                  UserService.update(temp).then((response) {
                    if (response.statusCode == HttpStatus.ok) {
                      context.read<UserProvider>().changeUser(user: temp);
                      showDialog(
                          context: context,
                          builder: (context) => const DolanDialog(
                              title: "Berhasil",
                              content: "Profile berhasil diperbarui",
                              buttonText: "Ok"));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const DolanDialog(
                              title: "Gagal",
                              content: "Something Error",
                              buttonText: "Ok"));
                    }
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => const DolanDialog(
                          title: "Oppss!",
                          content: "Pastikan semua filed tidak kosong",
                          buttonText: "Mengerti"));
                }
              },
              title: "Simpan"),
        ],
      ),
    );
  }
}
