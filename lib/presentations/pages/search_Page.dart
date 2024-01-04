import 'dart:convert';
import 'dart:io';

import 'package:dolan_yuk/components/cards/dolanDialog.dart';
import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:dolan_yuk/services/schedule_Service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/cards/schedule.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Map<String, dynamic> searchResult = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SearchBar(
                  onSubmitted: (value) {
                    ScheduleService.seacrhByName(value).then((value) {
                      setState(() {
                        searchResult = jsonDecode(value.body);
                      });
                    });
                  },
                  padding: const MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 20)),
                  leading: const Icon(Icons.search),
                ),
                const SizedBox(height: 10),
                ...searchResult.entries.map((item) => ScheduleCard(
                    id_schedule: item.value["id"],
                    title: item.value["group_name"] ?? "",
                    date: item.value["date"] ?? "",
                    time: item.value["time"] ?? "",
                    location: item.value["loc"] ?? "",
                    address: item.value["address"] ?? "",
                    min_member: item.value["min_member"],
                    textButton: "Join",
                    onPressed: () {
                      // context.goNamed('room');
                      ScheduleService.join(
                              context.read<UserProvider>().currentUser.id,
                              item.value["id"])
                          .then((response) {
                        if (response.statusCode == HttpStatus.ok) {
                          showDialog(
                              context: context,
                              builder: (context) => const DolanDialog(
                                  title: "Sukses Join!",
                                  content:
                                      "Selamat, kamu berhasil join pada jadwal dolanan. Kamu bisa ngobrol bareng teman-teman dolananmu. Teman-temanmu menghargai komitmenmu untuk hadir dan bermain bersama!!",
                                  buttonText: "Keren!"));
                        } else if (response.statusCode == HttpStatus.conflict) {
                          showDialog(
                              context: context,
                              builder: (context) => const DolanDialog(
                                  title: "Oppss!",
                                  content:
                                      "Mohon maaf, anda sudah masuk kedalam party",
                                  buttonText: "Ok"));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => const DolanDialog(
                                  title: "Gagal Join!",
                                  content: "Mohon maaf, terjadi kesalahan",
                                  buttonText: "Ok"));
                        }
                      });
                    })),
              ],
            )));
  }
}
