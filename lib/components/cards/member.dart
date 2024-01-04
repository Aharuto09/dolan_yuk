import 'package:dolan_yuk/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({super.key, required this.member, required this.minMember});
  final Map<String, dynamic> member;
  final int minMember;
  @override
  Widget build(BuildContext context) {
    int idUser = context.read<UserProvider>().currentUser.id;
    return Container(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
      decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 90,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Konco Dolanan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Member bergabung 3/$minMember",
                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                ...member.entries.map((item) => Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.only(bottom: 15),
                      color: Colors.white,
                      child: Row(
                        children: [
                          const CircleAvatar(),
                          const SizedBox(width: 10),
                          Text(item.value["name"]),
                          if (int.parse(item.key) == idUser)
                            const Text(" (You)")
                        ],
                      ),
                    )),
              ],
            ),
          )),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text("Keren!")),
              )),
        ],
      ),
    );
  }
}
