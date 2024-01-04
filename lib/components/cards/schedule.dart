import 'dart:convert';

import 'package:dolan_yuk/components/cards/member.dart';
import 'package:dolan_yuk/services/schedule_Service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.date,
      required this.time,
      required this.location,
      required this.address,
      required this.textButton,
      required this.min_member,
      required this.id_schedule});
  final String title, date, time, location, address, textButton;
  final int min_member, id_schedule;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    DateTime dolanDate;
    try {
      dolanDate = DateTime.parse(date);
    } catch (e) {
      dolanDate = DateTime.parse("2024-12-06");
    }
    return Card(
      elevation: 12,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
          ),
          Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(DateFormat.yMMMMEEEEd().format(dolanDate)),
                  Text(time.replaceAll('-', '.')),
                  FutureBuilder(
                      future: ScheduleService.getMember(id_schedule),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          final Map<String, dynamic> result =
                              jsonDecode(snapshot.data!.body);
                          // print(result.length);
                          return OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: MemberCard(
                                    member: result,
                                    minMember: min_member,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal:
                                        (MediaQuery.of(context).size.width > 100
                                            ? 10
                                            : 5)),
                                maximumSize: const Size(120, 50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.card_membership,
                                  color: Colors.deepPurple,
                                ),
                                Flexible(
                                  // constraints: BoxConstraints(maxWidth: 60),
                                  child: Text(
                                    " ${result.length}/$min_member Orang",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                  const SizedBox(height: 10),
                  Text(location),
                  Text(address),
                ],
              )),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    onPressed: onPressed, child: Text(textButton)),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
