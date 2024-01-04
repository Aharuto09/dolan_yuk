import 'dart:convert';
import 'package:dolan_yuk/components/cards/schedule.dart';
import 'package:dolan_yuk/models/room.dart';
import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:dolan_yuk/services/schedule_Service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder(
            future: ScheduleService.getAll(
                context.read<UserProvider>().currentUser.id),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> result = jsonDecode(snapshot.data!.body);
                // print(result);
                if (result.isNotEmpty) {
                  return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ...result.entries.map((item) => ScheduleCard(
                              id_schedule: item.value["id"],
                              title: item.value["group_name"] ?? "",
                              date: item.value["date"] ?? "",
                              time: item.value["time"] ?? "",
                              location: item.value["loc"] ?? "",
                              address: item.value["address"] ?? "",
                              min_member: item.value["min_member"],
                              textButton: "Party Chat",
                              onPressed: () {
                                context.goNamed('room',
                                    extra: Room(
                                        username: context
                                            .read<UserProvider>()
                                            .currentUser
                                            .username,
                                        id_schedule: item.value["id"],
                                        name: item.value["group_name"] ??
                                            "no_name"));
                              })),
                          const SizedBox(height: 40),
                        ],
                      ));
                } else {
                  return const Center(
                      child: Column(
                    children: [
                      Text("Jadwal main masih kosong nih"),
                      Text("Cari konco main atau bikin jadwal baru aja"),
                    ],
                  ));
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox.square(
                    dimension: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const Center(
                    child: Column(
                  children: [
                    Text("Jadwal main masih kosong nih"),
                    Text("Cari konco main atau bikin jadwal baru aja"),
                  ],
                ));
              }
            }),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: () {
              context.goNamed('add');
            },
            child: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }
}
